import 'package:flutter/material.dart';

class StatsProvider extends ChangeNotifier{
  List<double> _statList = [];

  List<double> get notificationList => _statList;


  void setStatList(List<double> list) {
    _statList = list;
    notifyListeners();
  }

  void setNotificationEmpty() {
    _statList = [];
    notifyListeners();
  }
}