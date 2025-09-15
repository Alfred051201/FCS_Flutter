// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TChartStat {
  final int year;
  final int month;
  final int count;

  TChartStat({
    required this.year, 
    required this.month, 
    required this.count
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'count': count,
    };
  }

  factory TChartStat.fromMap(Map<String, dynamic> map) {
    return TChartStat(
      year: map['year'] as int,
      month: map['month'] as int,
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TChartStat.fromJson(String source) => TChartStat.fromMap(json.decode(source) as Map<String, dynamic>);
}
