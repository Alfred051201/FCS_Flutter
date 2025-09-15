import 'package:fcs_flutter/common/widgets/bottom_bar.dart';
import 'package:fcs_flutter/features/admin/admin_home/screens/admin_screen.dart';
import 'package:fcs_flutter/features/auth/screens/login_screen.dart';
import 'package:fcs_flutter/providers/address_provider.dart';
import 'package:fcs_flutter/providers/feedback_provider.dart';
import 'package:fcs_flutter/providers/notification_provider.dart';
import 'package:fcs_flutter/providers/stats_provider.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/router.dart';
import 'package:fcs_flutter/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => FeedbackListProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => StatsProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AddressProvider(),
    )
  ],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback Collection System',
      theme: TAppTheme.theme,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? Provider.of<UserProvider>(context).user.role == 'user'
            ? const BottomBar()
            : const AdminScreen()
        : const LoginScreen(),
    );
  }
}
