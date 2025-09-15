import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fcs_flutter/features/home/services/feedback_service.dart';
import 'package:fcs_flutter/features/home/widgets/feedback_card.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FeedbackServices feedbackService = FeedbackServices();
  final List<String> _sorts = ["Newest", "Oldest"];
  final List<String> _categories = ['All', 'Bug Report', 'Feature Request', 'General Inquiry'];
  final List<String> _statuses  = ['All', 'Waiting to resolve', 'In Progress', 'Resolved'];
  String? _sortBy;
  String? _category;
  String? _status;
  DateTime? selectedDate;

  bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;


  @override
  Widget build(BuildContext context) {

    final feedbackList = Provider.of<FeedbackListProvider>(context).feedbackList;

    final filtered = feedbackList.where((f) {
      final matchesCategory = _category == null || _category == 'All' || f.category == _category;
      final matchesStatus = _status == null || _status == 'All' || f.status == _status;
      final matchesDate = selectedDate == null || _isSameDay(f.createdAt, selectedDate!);
      return matchesCategory && matchesStatus && matchesDate;
      
    }).toList();

    final visible = [...filtered]..sort((a, b) {
      return _sortBy == 'Newest'
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt);
    });

    return Scaffold(
      body: Column(
        children: [
          Divider(height: 4.0),
          const SizedBox(height: 8.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sort by: ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8.0,),
                SizedBox(
                  width: 240.0,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Sort by ...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: _sorts.map((String sort) => DropdownMenuItem<String>(
                        value: sort,
                        child: Text(
                          sort,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      )).toList(),
                      value: _sortBy,
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 35,
                        width: 260,
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        padding: const EdgeInsetsGeometry.all(0),
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        offset: const Offset(-20, 0),
                      )
                    )
                  )
                ),

                IconButton(
                  tooltip: "Clear filters",
                  onPressed: () => setState(() {
                    _sortBy = 'Newest';
                    _category = 'All';
                    _status = 'All';
                    selectedDate = null;
                  }), 
                  icon: const Icon(Icons.clear_all),
                )
              ],
            ),
          ),

          // sort by date oldest to newest
          // sort by date newest to oldest

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category: ', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width: 130.0,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Category',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: _categories.map((String category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          )).toList(),
                          value: _category,
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 35,
                            width: 160,
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            padding: const EdgeInsetsGeometry.all(0),
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            offset: const Offset(-20, 0),
                          )
                        )
                      )
                    )
                  ],
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status: ', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width: 130.0,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select status',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: _statuses.map((String status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          )).toList(),
                          value: _status,
                          onChanged: (value) {
                            setState(() {
                              _status = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 35,
                            width: 160,
                            padding: const EdgeInsets.only(left: 8, right: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            padding: const EdgeInsetsGeometry.all(0),
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            offset: const Offset(-20, 0),
                          )
                        )
                      )
                    )
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date: ', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4.0),
                  SizedBox(
                    height: 35,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: Colors.black26,
                            )
                          )
                        )
                      ),
                      onPressed: () {
                        selectDate();
                      }, 
                      child: Text(
                        selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  ],
                ),
                
              ],
            ),
          ),
          
          // choose category
          // choose date
          // choose status

          visible.isEmpty
          ? Text('You don\'t have any feedback currently')
          : Expanded(
            child: ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                return FeedbackCard(feedback:  visible[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate() async {
    DateTime? _selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2000), 
      lastDate: DateTime(2050),
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (_selected != null) {
      setState(() {
        selectedDate = _selected;
      });
    }
  }  
}