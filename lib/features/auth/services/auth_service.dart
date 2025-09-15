import 'dart:convert';

import 'package:fcs_flutter/common/widgets/bottom_bar.dart';
import 'package:fcs_flutter/features/admin/admin_home/screens/admin_screen.dart';
import 'package:fcs_flutter/features/auth/screens/login_screen.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/error_handling.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:fcs_flutter/utils/constants/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  void signUpUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () {
          showSnackBar(
            context, 
            'Account created! Login with the same credentials!'
          );
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
  }) async {
    try {

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/login'),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res, 
        context: context, 
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          final decodedBody = jsonDecode(res.body);
          final token = decodedBody['token'];
          final role = decodedBody['role'];
          if (token != null) {
            await prefs.setString('x-auth-token', token);
          } else {
            showSnackBar(context, 'Login failed: token missing in response.');
            return;
          }
          if (role == 'admin') {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              AdminScreen.routeName, 
              (route) => false
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              BottomBar.routeName, 
              (route) => false,
            );
          }
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOutUser({
    required BuildContext context,
  }) async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.body.isNotEmpty) {
        print('hi');
      }

      Provider.of<UserProvider>(context, listen: false).setEmpty();
      Provider.of<FeedbackListProvider>(context, listen: false).setFeedbackEmpty();
      Provider.of<NotificationProvider>(context, listen: false).setNotificationEmpty();
      await prefs.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context, 
        LoginScreen.routeName, 
        (route) => false,
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}
