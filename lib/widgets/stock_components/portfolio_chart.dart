import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/portfolio_history.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Builds a stock chart widget displaying a user's portfolio history.
///
/// This function creates a visual representation of the portfolio history
/// using a line chart and a sparkline chart from the Syncfusion Flutter Charts package.
/// It displays the portfolio value over time, with different colors indicating
/// increases or decreases in value.
///
/// [portfolioHistory] is a list of PortfolioHistory objects containing the historical data.
Widget buildPortfolioChart(List<PortfolioHistory> portfolioHistory) {
  DateTime now = DateTime.now();
  DateTime endTime = DateTime(now.year, now.month, now.day, now.hour);

  // Check if the data covers the last 24 hours
  DateTime earliestDataPoint = portfolioHistory.isNotEmpty
      ? portfolioHistory.first.date
      : DateTime.now().subtract(const Duration(hours: 24));
  DateTime startTime = earliestDataPoint
          .isBefore(DateTime.now().subtract(const Duration(hours: 24)))
      ? earliestDataPoint
      : DateTime(now.year, now.month, now.day, now.hour)
          .subtract(const Duration(hours: 24));

  return Column(
    children: [
      // SfCartesianChart is used to create a line chart.
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
            xValueMapper: (PortfolioHistory history, _) => history.date,
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
