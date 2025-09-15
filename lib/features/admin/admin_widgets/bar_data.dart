// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fcs_flutter/features/admin/admin_widgets/individual_bar.dart';

class BarData {
  final double janAmount;
  final double febAmount;
  final double marAmount;
  final double aprAmount;
  final double mayAmount;
  final double junAmount;
  final double julAmount;
  final double augAmount;
  final double sepAmount;
  final double octAmount;
  final double novAmount;
  final double decAmount;

  BarData({
    required this.janAmount,
    required this.febAmount,
    required this.marAmount,
    required this.aprAmount,
    required this.mayAmount,
    required this.junAmount,
    required this.julAmount,
    required this.augAmount,
    required this.sepAmount,
    required this.octAmount,
    required this.novAmount,
    required this.decAmount,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: janAmount),
      IndividualBar(x: 1, y: febAmount),
      IndividualBar(x: 2, y: marAmount),
      IndividualBar(x: 3, y: aprAmount),
      IndividualBar(x: 4, y: mayAmount),
      IndividualBar(x: 5, y: junAmount),
      IndividualBar(x: 6, y: julAmount),
      IndividualBar(x: 7, y: augAmount),
      IndividualBar(x: 8, y: sepAmount),
      IndividualBar(x: 9, y: octAmount),
      IndividualBar(x: 10, y: novAmount),
      IndividualBar(x: 11, y: decAmount),
    ];
  }

}
