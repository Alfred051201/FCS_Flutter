import 'package:fcs_flutter/features/summary/screens/summary_screen.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackSummaryButton extends StatelessWidget {
  const FeedbackSummaryButton({
    super.key,
    required this.feedback,
  });

  final TFeedback feedback;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, FeedbackSummaryScreen.routeName, arguments: feedback);
      }, 
      style: TextButton.styleFrom(
        backgroundColor: 
          feedback.status == 'Waiting to resolve' 
            ? Colors.red[200]
            : feedback.status == 'In Progress'
              ? Colors.yellow[200]
              : Colors.green[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        minimumSize: const Size(0, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Go to summary',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}