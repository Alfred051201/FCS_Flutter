import 'package:fcs_flutter/features/admin/admin_resolve/screens/admin_resolve_screen.dart';
import 'package:fcs_flutter/models/feedback.dart';
import 'package:flutter/material.dart';

class ResolveFeedbackButton extends StatelessWidget {
  const ResolveFeedbackButton({
    super.key,
    required this.feedback,
    this.onResolved,
  });

  final TFeedback feedback;
  final VoidCallback? onResolved;
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, AdminResolveScreen.routeName, arguments: feedback).then((_) {
          if (onResolved != null) onResolved!();
        });
      }, 
      style: TextButton.styleFrom(
        backgroundColor: 
          feedback.status == 'Waiting to resolve' 
            ? Colors.red[200]
            : feedback.status == 'In Progress'
              ? Colors.yellow[200]
              : Colors.green[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        minimumSize: const Size(0, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Go to resolve',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}