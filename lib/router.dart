import 'package:fcs_flutter/common/widgets/bottom_bar.dart';
import 'package:fcs_flutter/features/admin/admin_home/screens/admin_feedback_screen.dart';
import 'package:fcs_flutter/features/admin/admin_home/screens/admin_screen.dart';
import 'package:fcs_flutter/features/admin/admin_resolve/screens/admin_resolve_screen.dart';
import 'package:fcs_flutter/features/auth/screens/login_screen.dart';
import 'package:fcs_flutter/features/auth/screens/signup_screen.dart';
import 'package:fcs_flutter/features/summary/screens/summary_screen.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {

    case SignupScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const SignupScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        builder: (_) => const BottomBar(),
      );

    case AdminScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AdminScreen(),
      );

    case AdminFeedbackScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AdminFeedbackScreen(),
      );

    case FeedbackSummaryScreen.routeName:
      var feedback = routeSettings.arguments as TFeedback?;
      return MaterialPageRoute(
        builder: (_) => FeedbackSummaryScreen(
          feedback: feedback!,
        ),
      );
    
    case AdminResolveScreen.routeName:
      var feedback = routeSettings.arguments as TFeedback;
      return MaterialPageRoute(
        builder: (_) => AdminResolveScreen(
          feedback: feedback,
        ),
      );

    default: 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        )
      );
  }
}