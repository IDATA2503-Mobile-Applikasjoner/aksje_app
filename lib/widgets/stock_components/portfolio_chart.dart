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
/// [portfolioHistory]
Widget buildPortfolioChart(List<PortfolioHistory> portfolioHistory) {
  return Column(
    children: [
      SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<PortfolioHistory, String>>[
          AreaSeries<PortfolioHistory, String>(
            dataSource: portfolioHistory,
            xValueMapper: (PortfolioHistory history, _) => history.date,
            yValueMapper: (PortfolioHistory history, _) => history.price,
            name: "Price",
            borderWidth: 2,
            borderColor: Colors.blue,
            gradient: const LinearGradient(
              colors: [
                Colors.blue,
                Colors.transparent,
              ],
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
