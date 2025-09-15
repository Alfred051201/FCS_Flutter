import 'package:fcs_flutter/features/admin/admin_widgets/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List yearlySummary;
  const MyBarGraph({
    super.key,
    required this.yearlySummary,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      janAmount: yearlySummary[0], 
      febAmount: yearlySummary[1], 
      marAmount: yearlySummary[2], 
      aprAmount: yearlySummary[3],  
      mayAmount: yearlySummary[4], 
      junAmount: yearlySummary[5], 
      julAmount: yearlySummary[6], 
      augAmount: yearlySummary[7],  
      sepAmount: yearlySummary[8], 
      octAmount: yearlySummary[9], 
      novAmount: yearlySummary[10], 
      decAmount: yearlySummary[11],  
    );

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, 
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [
                BarChartRodData(
                  toY: data.y, 
                  color: Colors.grey[800],
                  width: 25,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: Colors.grey[200],
                  )
                ),
              ]
            ),
          ).toList(),
      )
    );
  }
}

Widget getBottomTitles (double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('J', style: style);
      break;
    case 1:
      text = const Text('F', style: style);
      break;
    case 2:
      text = const Text('M', style: style);
      break;
    case 3:
      text = const Text('A', style: style);
      break;
    case 4:
      text = const Text('M', style: style);
      break;
    case 5:
      text = const Text('J', style: style);
      break;
    case 6:
      text = const Text('J', style: style);
      break;
    case 7:
      text = const Text('A', style: style);
      break;
    case 8:
      text = const Text('S', style: style);
      break;
    case 9:
      text = const Text('O', style: style);
      break;
    case 10:
      text = const Text('N', style: style);
      break;
    case 11:
      text = const Text('D', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, meta: meta);
}