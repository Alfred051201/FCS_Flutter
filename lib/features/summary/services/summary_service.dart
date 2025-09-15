import 'dart:convert';

import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/error_handling.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SummaryService {
  void rateFeedback({
    required BuildContext context,
    required String feedbackId,
    required double rating,
    VoidCallback? onComplete,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final feedbackListProvider = Provider.of<FeedbackListProvider>(context, listen: false);
      http.Response res = await http
        .put(Uri.parse('$uri/api/feedback/rating'), 
        body: jsonEncode({
          'feedbackId': feedbackId,
          'rating': rating,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        }
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          feedbackListProvider.updateFeedback(
            TFeedback.fromJson(
              jsonEncode(
                jsonDecode(res.body),
              ),
            ),
          );
          showSnackBar(context,'Finish rating feedback!');
          if (onComplete != null) onComplete();
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }
}
