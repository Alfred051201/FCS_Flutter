import 'package:flutter/material.dart';

class AdminCard extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final double stat;
  final String unit;
  const AdminCard({
    super.key,
    required this.color,
    required this.title,
    required this.icon,
    required this.stat,
    required this.unit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 50,
          spreadRadius: 7,
          offset: const Offset(0, 2),
        )],
        borderRadius: BorderRadius.circular(12.0),
        color: color.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                height: 1.2,
                fontWeight: FontWeight.w800, 
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: unit == "feedbacks" 
                          ? '${stat.round()}'
                          : '$stat',
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: ' $unit',
                          style: TextStyle(
                            fontSize: 12.0,
                          )
                        )
                      ]
                    )
                  )
                ),
                CircleAvatar(
                  backgroundColor: color,
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '+10% from last month',
              style: TextStyle(
                fontSize: 11.0,
                color: const Color(0xFF023e8a),
              ),
            )
          ],
        ),
      )
    );
  }
}