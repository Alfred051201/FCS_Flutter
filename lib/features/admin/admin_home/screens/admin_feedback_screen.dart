import 'package:fcs_flutter/features/home/services/feedback_service.dart';
import 'package:fcs_flutter/features/home/widgets/feedback_card.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminFeedbackScreen extends StatefulWidget {
  static const String routeName = '/admin-feedback';
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {

  final FeedbackServices feedbackService = FeedbackServices();

  @override
  Widget build(BuildContext context) {
    final feedbackList = Provider.of<FeedbackListProvider>(context).feedbackList;
    return Scaffold(
      body: Column(
        children: [
          Divider(height: 4.0),
          feedbackList.isEmpty
          ? Text('There is no feedback currently')
          : Expanded(
            child: ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                return FeedbackCard(
                  feedback:  feedbackList[index],
                  onResolved: () {
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}