import 'package:fcs_flutter/common/widgets/loader.dart';
import 'package:fcs_flutter/features/admin/admin_home/services/admin_service.dart';
import 'package:fcs_flutter/features/admin/admin_widgets/admin_card.dart';
import 'package:fcs_flutter/features/admin/admin_widgets/line_chart.dart';
import 'package:fcs_flutter/models/chartStat.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService adminService = AdminService();

  List<String> titleList = [
    "Total Feedbacks",
    "New Feedback",
    "Currently Resolving",
    "Total Resolved",
    "Time taken",
    "Average Rating",
  ];

  List<Color> colorList = [
    const Color(0xFF412722),
    const Color(0xFFF6DBAE),
    const Color(0xFFA51C28),
    const Color(0xFF680F1A),
    const Color(0xFF1B512D),
    const Color(0xFF0C7C59),
  ];

  List<IconData> iconList = [
    Icons.feedback,
    Icons.fiber_new,
    Icons.timelapse,
    Icons.task_alt,
    Icons.access_time_rounded,
    Icons.star_half,
  ];

  List<String> unitList = [
    "feedbacks",
    "feedbacks",
    "feedbacks",
    "feedbacks",
    "days",
    "stars",
  ];

  List<double> statsList = [0, 0, 0, 0, 0, 0];
  List<List<TChartStat>>? chartStatList;

  fetchAdminCardStats() async {
    statsList = await adminService.getAdminCardStats(context: context);
    if (!mounted) return;
    setState(() {});
  }

  fetchAdminLineChartStats() async {
    chartStatList = await adminService.getAdminLineChartStats(context: context);
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAdminCardStats();
    fetchAdminLineChartStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 4),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Highlights ",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: "Last 28 days",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ]
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 12.0),
              child: GridView.builder(
                itemCount: titleList.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  mainAxisExtent: 100,
                ), 
                itemBuilder: (_, index) => AdminCard(
                  title: titleList[index],
                  color: colorList[index],
                  icon: iconList[index],
                  stat: statsList[index],
                  unit: unitList[index],
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: const Text(
                "Yearly Overview ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: SizedBox(
                height: 200,
                child: chartStatList == null
                  ? const Loader()
                  : SizedBox(
                      height: 400,
                      width: 400,
                      child: AdminLineChart(
                        allStatList: chartStatList!,
                      )
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.purple,
                  width: 20,
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  color: Colors.red,
                  width: 20,
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Resolved",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    )
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}