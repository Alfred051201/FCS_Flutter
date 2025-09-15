import 'dart:convert';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FeedbackServices {

  void fetchUserFeedback({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<TFeedback> feedbackList = [];
    try {
      http.Response res = await http
        .get(Uri.parse('$uri/api/feedback/user'), 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });
      
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        feedbackList.add(
          TFeedback.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }
      Provider.of<FeedbackListProvider>(context, listen: false).setFeedbackList(feedbackList);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void fetchAllFeedback({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<TFeedback> feedbackList = [];
    try {
      http.Response res = await http
        .get(Uri.parse('$uri/api/feedback'), 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });
      
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        feedbackList.add(
          TFeedback.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }

      Provider.of<FeedbackListProvider>(context, listen: false).setFeedbackList(feedbackList);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}