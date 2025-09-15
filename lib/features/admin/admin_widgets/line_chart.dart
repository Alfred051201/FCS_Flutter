import 'package:fcs_flutter/models/chartStat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminLineChart extends StatefulWidget {
  final List<List<TChartStat>> allStatList;
  const AdminLineChart({
    super.key,
    required this.allStatList,
  });

  @override
  State<AdminLineChart> createState() => _AdminLineChartState();
}

class _AdminLineChartState extends State<AdminLineChart> {
  @override
  Widget build(BuildContext context) {

    final List<TChartStat> allFeedbackList = widget.allStatList[0];
    final List<TChartStat> allResolvedFeedbackList = widget.allStatList[1];

    return LineChart(
      LineChartData(
        gridData: gridData,
        titlesData: titlesData(allFeedbackList),
        borderData: borderData,
        lineBarsData: [
          getLineChartBarData1(allFeedbackList),
          getLineChartBarData2(allResolvedFeedbackList),
        ],
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: _calculateMaxY(allFeedbackList) > _calculateMaxY(allResolvedFeedbackList) ? _calculateMaxY(allFeedbackList) : _calculateMaxY(allResolvedFeedbackList),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBorder: BorderSide(
              color: Colors.grey.shade400,
              width: 1.2,
            ),
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            tooltipBorderRadius: BorderRadius.circular(8.0),
            getTooltipColor: (spots) => Colors.white,
            getTooltipItems: (touchedSpots) {      
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} feedbacks',
                  TextStyle(
                    color: spot.bar.gradient?.colors.first ?? spot.bar.color ?? Colors.black
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}

double _calculateMaxY(List<TChartStat> stats) {
  int max = 0;
  for (var stat in stats) {
    if (stat.count > max) {
      max = stat.count;
    }
  }
  return max + 1;
}

FlTitlesData titlesData(List<TChartStat> stats) => FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: bottomTiles(stats),
  ),
  rightTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false)
  ),
  topTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false)
  ),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false)
  )
);

Widget bottomTitleWidgets(double value, TitleMeta meta, List<TChartStat> stats) {
  const style = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
  
  final index = value.toInt() - 1;
  if (index < 0 || index >= stats.length) {
    return const SizedBox.shrink();
  }
  final stat = stats[index];

  final label = '${monthMap[stat.month]}';

  return SideTitleWidget(meta: meta, space: 1, child: Text(label, style: style));
} 

SideTitles bottomTiles(List<TChartStat> stats) => SideTitles(
  showTitles: true,
  reservedSize: 32,
  interval: 1,
  getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, stats),
);

FlGridData get gridData => FlGridData(show: false);

FlBorderData get borderData => FlBorderData(
  show: true,
  border: Border(
    bottom: BorderSide(color: Colors.grey, width: 4),
    left: const BorderSide(color: Colors.grey),
    right: const BorderSide(color: Colors.transparent),
    top: const BorderSide(color: Colors.transparent),
  )
);

LineChartBarData getLineChartBarData1(List<TChartStat> stats) {
  return LineChartBarData(
    isCurved: true,
    color: Colors.purple,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          Colors.purple.withValues(alpha: 0.2),
          Colors.purple.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    spots: List.generate(
      stats.length,
      (i) => FlSpot((i + 1).toDouble(), stats[i].count.toDouble()),
    ),
  );
}

LineChartBarData getLineChartBarData2(List<TChartStat> stats) {
  return LineChartBarData(
    isCurved: true,
    color: Colors.red,
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          Colors.red.withValues(alpha: 0.2),
          Colors.red.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    spots: List.generate(
      stats.length,
      (i) => FlSpot((i + 1).toDouble(), stats[i].count.toDouble()),
    ),
  );
}

const Map<int, String> monthMap = {
  1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr', 5: 'May', 6: 'Jun',
  7: 'Jul', 8: 'Aug', 9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dec'
};