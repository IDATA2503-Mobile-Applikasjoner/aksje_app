import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/portfolio_history.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// Utility function to convert a DateTime instance to GMT+1 time zone.
DateTime toGMT1(DateTime dateTime) {
  // Adds one hour to the given DateTime to adjust for GMT+1.
  return dateTime.add(const Duration(hours: 1));
}

// Widget to build a portfolio chart using Syncfusion Flutter Charts.
Widget buildPortfolioChart(List<PortfolioHistory> portfolioHistory) {
  // Get the current time and convert it to GMT+1.
  DateTime nowGMT1 = toGMT1(DateTime.now());
  // Define the end time for the chart as the start of the current hour in GMT+1.
  DateTime endTime =
      DateTime(nowGMT1.year, nowGMT1.month, nowGMT1.day, nowGMT1.hour);

  // Determine the earliest data point in the portfolio history, converting it to GMT+1.
  // If there's no data, use the last 24 hours as the default range.
  DateTime earliestDataPoint = portfolioHistory.isNotEmpty
      ? toGMT1(portfolioHistory.first.date)
      : toGMT1(DateTime.now()).subtract(const Duration(hours: 24));
  // Define the start time for the chart, ensuring it covers the last 24 hours in GMT+1.
  DateTime startTime = earliestDataPoint
          .isBefore(toGMT1(DateTime.now()).subtract(const Duration(hours: 24)))
      ? earliestDataPoint
      : DateTime(nowGMT1.year, nowGMT1.month, nowGMT1.day, nowGMT1.hour)
          .subtract(const Duration(hours: 24));

  // Create a column widget to hold the chart.
  return Column(
    children: [
      // Create a Cartesian chart (line chart) to display the data.
      SfCartesianChart(
        // Define the X-axis as a DateTimeCategoryAxis to handle date values.
        primaryXAxis: DateTimeCategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          majorGridLines: const MajorGridLines(width: 0),
          // Set the visible range of the x-axis.
          visibleMinimum: startTime,
          visibleMaximum: endTime,
        ),
        // Define the Y-axis as a numeric axis.
        primaryYAxis: NumericAxis(),
        // Define the series of data points to be plotted.
        series: <ChartSeries<PortfolioHistory, DateTime>>[
          // Use AreaSeries to create an area chart.
          AreaSeries<PortfolioHistory, DateTime>(
            // Bind the data source for the series.
            dataSource: portfolioHistory,
            // Map the x-value (date) of each data point.
            xValueMapper: (PortfolioHistory history, _) => toGMT1(history.date),
            // Map the y-value (price) of each data point.
            yValueMapper: (PortfolioHistory history, _) => history.price,
            // Set series name and styling options.
            name: 'Price',
            borderWidth: 2,
            borderColor: Colors.blue,
            // Define a gradient for the area under the curve.
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
