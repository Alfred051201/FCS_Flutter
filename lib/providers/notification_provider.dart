import 'package:fcs_flutter/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<TNotification> _notificationList = [];

  List<TNotification> get notificationList => _notificationList;

  void setNotificationList(List<TNotification> list) {
    _notificationList = list;
    notifyListeners();
  }

  void setNotificationEmpty() {
    _notificationList = [];
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notificationList.removeWhere((notification) => notification.id == notificationId);
    notifyListeners();
  }
  
  // void updateFeedback(TFeedback updated) {
  //   final index = _feedbackList.indexWhere((f) => f.id == updated.id);
  //   if (index != -1) {
  //     _feedbackList[index] = updated;
  //     notifyListeners();
  //   }
  // }

  // TFeedback? getFeedbackById(String id) {
  //   try {
  //     return _feedbackList.firstWhere((f) => f.id == id);
  //   } catch (e) {
  //     return null;
  //   }
  // }
}