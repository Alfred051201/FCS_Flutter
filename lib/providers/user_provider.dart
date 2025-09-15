import 'package:fcs_flutter/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    username: '', 
    email: '',
    password: '',
    token: ''
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setEmpty() {
    _user = User(username: '', email: '', password: '', token: '');
    notifyListeners();
  }
}