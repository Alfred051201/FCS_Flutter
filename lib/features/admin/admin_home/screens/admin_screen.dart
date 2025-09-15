import 'package:fcs_flutter/features/admin/admin_home/screens/admin_dashboard.dart';
import 'package:fcs_flutter/features/admin/admin_home/screens/admin_feedback_screen.dart';
import 'package:fcs_flutter/features/admin/admin_home/services/admin_service.dart';
import 'package:fcs_flutter/features/auth/services/auth_service.dart';
import 'package:fcs_flutter/features/home/services/feedback_service.dart';
import 'package:fcs_flutter/features/notification/screens/notification_screen.dart';
import 'package:fcs_flutter/features/notification/services/notification_services.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-home';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminScreen> {


  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const AdminDashboardScreen(),
    const AdminFeedbackScreen(),
    const NotificationScreen(),
  ];

  final AuthService authService = AuthService();
  final FeedbackServices feedbackService = FeedbackServices();
  final NotificationServices notificationServices = NotificationServices();
  final AdminService adminService = AdminService();

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  fetchAllFeedbacks() {
    feedbackService.fetchAllFeedback(context: context);
    setState(() {});
  }

  fetchUserNotifications() {
    notificationServices.fetchNotification(context: context);
    setState(() {});
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      fetchAllFeedbacks();
      fetchUserNotifications();
      _isInit = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), 
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Feedback Collection System'),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {}, 
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                  child: TextButton(
                    onPressed: () {
                      authService.signOutUser(context: context);
                    },                    
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ), 
                  )
                ),
              ),
            ],
          ),
        )
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: const Icon(
                Icons.upload_file,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                      ? GlobalVariables.selectedNavBarColor
                      : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  )
                )
              ),
              child: const Icon(
                Icons.notification_important,
              ),
            ),
            label: '',
          )
        ]
      ),
    );
  }
}