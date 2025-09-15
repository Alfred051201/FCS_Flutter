import 'package:fcs_flutter/features/admin/admin_resolve/screens/admin_resolve_screen.dart';
import 'package:fcs_flutter/features/notification/services/notification_services.dart';
import 'package:fcs_flutter/features/summary/screens/summary_screen.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/models/notification.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/utils/constants/dateToString.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  final TNotification notification;
  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final NotificationServices notificationServices = NotificationServices();
    final feedbackList = Provider.of<FeedbackListProvider>(context).feedbackList;
    TFeedback currFeedback = feedbackList.firstWhere(
      (f) => f.id == notification.feedbackId
    );
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: notification.type == "New Feedback" ? Colors.red : Colors.green,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                child: Row(
                                  children: [
                                    notification.type == "New Feedback" 
                                    ? Icon(
                                      CupertinoIcons.exclamationmark_circle,
                                      color: Colors.white,
                                    ) 
                                    : Icon(
                                      Icons.check_circle_outline_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      notification.type,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Icon(CupertinoIcons.exclamationmark_circle),
                            // Icon(Icons.check_circle_outline_outlined)
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 38,
                          width: 300,
                          child: Text.rich(
                            TextSpan(      
                              children: [
                                if (notification.type == "New Feedback") ... [
                                  TextSpan(
                                    text: "User ${currFeedback.name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " submitted a new feedback. "
                                  )
                                ] else ...[
                                  TextSpan(
                                    text: "Your feedback is resolved. ",
                                  )
                                ],
                                TextSpan(
                                  text: 
                                    notification.type != "New Feedback" 
                                    ? "Check\u00A0it\u00A0here"
                                    : "Go\u00A0resolve",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color.fromARGB(255, 28, 142, 235),
                                    color: const Color.fromARGB(255, 28, 142, 235),
                                    // fontStyle: FontStyle.italic,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                          context, 
                                          notification.type == "New Feedback"
                                          ? AdminResolveScreen.routeName
                                          : FeedbackSummaryScreen.routeName, 
                                          arguments: currFeedback
                                        );
                                      },
                                ),
                              ],
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[800],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                            timeAgo(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12.0,
                              wordSpacing: -1.0,
                              color: Colors.grey[500],
                            ),
                        ),
                      ],
                    ),
                  SizedBox(
                    width: 60,
                    child: GestureDetector(
                      onTap: () {
                        notificationServices.deleteNotification(
                          context: context, 
                          notificationId: notification.id!
                        );
                      },
                      child: Icon(
                        CupertinoIcons.delete,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}