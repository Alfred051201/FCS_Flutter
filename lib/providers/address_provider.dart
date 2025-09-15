import 'package:fcs_flutter/models/addressModel.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier{
  Addressmodel? currentLocation;

  void updateCurrentLocation(Addressmodel cuurentlocation) {
    currentLocation = cuurentlocation;
    notifyListeners();
  }
}