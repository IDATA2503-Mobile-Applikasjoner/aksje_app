import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/portfolio_history.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// Utility function to convert DateTime to GMT+1
DateTime toGMT1(DateTime dateTime) {
  return dateTime.add(const Duration(hours: 1));
}

Widget buildPortfolioChart(List<PortfolioHistory> portfolioHistory) {
  DateTime nowGMT1 = toGMT1(DateTime.now());
  DateTime endTime =
      DateTime(nowGMT1.year, nowGMT1.month, nowGMT1.day, nowGMT1.hour);

  // Check if the data covers the last 24 hours in GMT+1
  DateTime earliestDataPoint = portfolioHistory.isNotEmpty
      ? toGMT1(portfolioHistory.first.date)
      : toGMT1(DateTime.now()).subtract(const Duration(hours: 24));
  DateTime startTime = earliestDataPoint
          .isBefore(toGMT1(DateTime.now()).subtract(const Duration(hours: 24)))
      ? earliestDataPoint
      : DateTime(nowGMT1.year, nowGMT1.month, nowGMT1.day, nowGMT1.hour)
          .subtract(const Duration(hours: 24));

  return Column(
    children: [
      SfCartesianChart(
        primaryXAxis: DateTimeCategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          majorGridLines: const MajorGridLines(width: 0),
          visibleMinimum: startTime,
          visibleMaximum: endTime,
        ),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<PortfolioHistory, DateTime>>[
          AreaSeries<PortfolioHistory, DateTime>(
            dataSource: portfolioHistory,
            xValueMapper: (PortfolioHistory history, _) => toGMT1(history.date),
            yValueMapper: (PortfolioHistory history, _) => history.price,
            name: 'Price',
            borderWidth: 2,
            borderColor: Colors.blue,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.transparent],
              stops: [0.0, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    ],
  );
}
