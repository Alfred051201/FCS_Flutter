import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/error_handling.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ResolveService {
  void startResolve({
    required BuildContext context,
    required TFeedback feedback,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final feedbackListProvider = Provider.of<FeedbackListProvider>(context, listen: false);
      http.Response res = await http
        .put(Uri.parse('$uri/api/feedback/start'), 
        body: jsonEncode({
          'feedbackId': feedback.id!,
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
          showSnackBar(context,'Start resolve feedback!');
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void finishResolve({
    required BuildContext context,
    required String feedbackId,
    required String userId,
    required String comment,
    required List<File> images,
    VoidCallback? onComplete,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final feedbackListProvider = Provider.of<FeedbackListProvider>(context, listen: false);
      
      final cloudinary = CloudinaryPublic('dqzpzhgss', 'xo3pxv4a');
      List<String> imageUrls = [];
      for(int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: feedbackId),
        );
        imageUrls.add(res.secureUrl);
      }

      http.Response res = await http
        .put(Uri.parse('$uri/api/feedback/finish'), 
        body: jsonEncode({
          'feedbackId': feedbackId,
          'userId': userId,
          'comment': comment,
          'images': imageUrls,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });

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
          showSnackBar(context, 'Product finish resolved!');
          if (onComplete != null) onComplete();
        }
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
