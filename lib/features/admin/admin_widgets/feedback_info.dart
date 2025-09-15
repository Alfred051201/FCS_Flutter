import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/utils/constants/dateToString.dart';
import 'package:flutter/material.dart';

class FeedbackInfo extends StatelessWidget {
  const FeedbackInfo({
    super.key,
    required this.feedback,
  });

  final TFeedback feedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedback.category, 
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                overflow: TextOverflow.ellipsis
              )
            ),
            const SizedBox(height: 4.0),
            SizedBox(
              width: 220,
              child: Text("${feedback.name}, ${feedback.email}", 
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12.0,
                )
              ),
            ),
            const SizedBox(height: 4.0),
            Text('Submitted on: ${dateToString(feedback.createdAt)}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),             
          ],
        ),
        Column(
          children: [
            Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              label: Text(feedback.status),
              backgroundColor: 
              feedback.status == 'Waiting to resolve' 
                ? Colors.red[100]
                : feedback.status == 'In Progress'
                  ? Colors.yellow[100]
                  : Colors.green[100],
              labelStyle: TextStyle(
                color: feedback.status == 'Waiting to resolve' 
                ? Colors.red[600]
                : feedback.status == 'In Progress'
                  ? Colors.amber[800]
                  : Colors.green[600],
                fontSize: 12.0
              ),
              labelPadding: EdgeInsets.zero,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
    );
  }
}