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
  return Column(
    children: [
      // SfCartesianChart is used to create a line chart.
      SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          majorGridLines: const MajorGridLines(width: 0),
        ), // X-axis is categorized by dates.
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<PortfolioHistory, String>>[
          AreaSeries<PortfolioHistory, String>(
            dataSource: portfolioHistory, // Data source for the chart.
            xValueMapper: (PortfolioHistory history, _) =>
                history.date, // Mapping the date for the X-axis.
            yValueMapper: (PortfolioHistory history, _) =>
                history.price, // Mapping the price for the Y-axis.
            name: "Price", // Name of the series.
            borderWidth: 2,
            borderColor: Colors.blue,
            gradient: const LinearGradient(
              // Define the gradient colors and stops.
              colors: [
                Colors.blue, // Blue at the line.
                Colors.transparent, // Transparent at the bottom.
              ],
              stops: [0.0, 1.0],
              begin: Alignment.topCenter, // Start the gradient from the top.
              end: Alignment.bottomCenter, // End the gradient at the bottom.
            ),
          ),
        ],
      ),
    ],
  );
}
