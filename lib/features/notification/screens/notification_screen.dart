import 'package:fcs_flutter/features/notification/widget/notification_card.dart';
import 'package:fcs_flutter/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationList = Provider.of<NotificationProvider>(context).notificationList;
    return Scaffold(
      body: Column(
        children: [
          Divider(height: 4.0),
          const SizedBox(height: 8.0,),
          notificationList.isEmpty
          ? Text('You don\'t have any notifications currently')
          : Expanded(
            child: ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notificationList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}