import 'package:fcs_flutter/models/feedback.dart';
import 'package:flutter/material.dart';

class FeedbackListProvider extends ChangeNotifier {
  List<TFeedback> _feedbackList = [];

  List<TFeedback> get feedbackList => _feedbackList;

  void setFeedbackList(List<TFeedback> list) {
    _feedbackList = list;
    notifyListeners();
  }

  void addFeedback(TFeedback feedback) {
    _feedbackList.add(feedback);
    notifyListeners();
  }

  void updateFeedback(TFeedback updated) {
    final index = _feedbackList.indexWhere((f) => f.id == updated.id);
    if (index != -1) {
      _feedbackList[index] = updated;
      notifyListeners();
    }
  }

  TFeedback? getFeedbackById(String id) {
    try {
      return _feedbackList.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  void setFeedbackEmpty() {
    _feedbackList = [];
    notifyListeners();
  }
}