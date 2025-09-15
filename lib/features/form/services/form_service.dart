import 'dart:convert';

import 'package:fcs_flutter/features/home/services/feedback_service.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/error_handling.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FormService {

  void submitFeedback({
    required BuildContext context,
    required String name,
    required String email,
    required String category,
    required String message,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final FeedbackServices feedbackServices = FeedbackServices();
      http.Response res = await http.post(
        Uri.parse('$uri/api/feedback'),
        body: jsonEncode({
          'name': name,
          'email': email,
          'category': category,
          'message': message,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );

      if (user.role == 'user') {
        feedbackServices.fetchUserFeedback(context: context);
      } else {
        feedbackServices.fetchAllFeedback(context: context);
      }

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackBar(
            context,
            'Your feedback is submitted! We hope to get back to you as soon as possible'
          );
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}