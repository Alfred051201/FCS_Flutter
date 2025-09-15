import 'dart:convert';

import 'package:fcs_flutter/models/chartStat.dart';
import 'package:fcs_flutter/providers/user_provider.dart';
import 'package:fcs_flutter/utils/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdminService {

  Future<List<double>> getAdminCardStats({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http
        .get(Uri.parse('$uri/api/feedback/stats'), 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });

      final data = jsonDecode(res.body);
      return [
        (data["totalFeedbackForLast28Days"] ?? 0).toDouble(),
        (data["newUnresolvedCountForLast28Days"] ?? 0).toDouble(),
        (data["InProgressCountForLast28Days"] ?? 0).toDouble(),
        (data["totalResolvedForLast28Days"] ?? 0).toDouble(),
        (data["averageResolveTime"] ?? 0).toDouble(),
        (data["averageRating"] ?? 0).toDouble(),
      ];    
    } catch (e) {
      // showSnackBar(context, e.toString());
      return [0, 0, 0, 0, 0, 0];
    }
  }

  Future<List<List<TChartStat>>> getAdminLineChartStats({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<TChartStat> totalFeedbackStatList = [];
    List<TChartStat> resolvedFeedbackStatList = [];
    try {
      http.Response res = await http
        .get(Uri.parse('$uri/api/feedback/stats/line'), 
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        });
      final data = jsonDecode(res.body);
      for (int i = 0; i < data[0].length; i++) {
        totalFeedbackStatList.add(
          TChartStat.fromJson(
            jsonEncode(
              data[0][i],
            ),
          ),
        );
        resolvedFeedbackStatList.add(
          TChartStat.fromJson(
            jsonEncode(
              data[1][i],
            ),
          ),
        );
      }
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
    return [totalFeedbackStatList, resolvedFeedbackStatList];
  }
}