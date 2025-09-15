import 'package:fcs_flutter/features/admin/admin_widgets/feedback_summary_button.dart';
import 'package:fcs_flutter/features/admin/admin_widgets/resolve_summary_button.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/dateToString.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackCard extends StatelessWidget {
  final TFeedback feedback;
  final VoidCallback? onResolved;

  const FeedbackCard({
    super.key,
    required this.feedback,
    this.onResolved,
  });

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<UserProvider>(context, listen: false).user.role == 'admin';
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: BoxBorder.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, // aligns column with text
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "${feedback.name}, ${feedback.email}",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text(dateToString(feedback.createdAt)),
              ],
            ),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    feedback.message,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                feedback.finishResolve != null
                  ? Text(getDurationDifference(feedback.startResolve!, feedback.finishResolve!))
                  : Text('In progress'),
            
                feedback.finishResolve == null && isAdmin
                ? ResolveFeedbackButton(feedback: feedback, onResolved: onResolved)
                : FeedbackSummaryButton(feedback: feedback)
              ],
            ),
          ],
        ),
      ),
    );
  }
}



