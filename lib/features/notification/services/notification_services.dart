import 'dart:convert';

import 'package:fcs_flutter/models/notification.dart';
import 'package:fcs_flutter/providers/notification_provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NotificationServices {

  void fetchNotification({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<TNotification> notificationList = [];
    try {
      http.Response res = await http
        .get(Uri.parse('$uri/api/notification/${userProvider.user.id}'), 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        notificationList.add(
          TNotification.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }
      Provider.of<NotificationProvider>(context, listen: false).setNotificationList(notificationList);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteNotification({
    required BuildContext context,
    required String notificationId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await http
        .delete(Uri.parse('$uri/api/notification/single'), 
        body: jsonEncode({
          'notificationId' : notificationId,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });
      Provider.of<NotificationProvider>(context, listen: false).deleteNotification(notificationId);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}