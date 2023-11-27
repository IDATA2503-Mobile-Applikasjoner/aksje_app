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
        primaryXAxis: CategoryAxis(), // X-axis is categorized by dates.
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableDoubleTapZooming: true,
          enableSelectionZooming: true,
          enableMouseWheelZooming: true,
        ),
        series: <ChartSeries<PortfolioHistory, String>>[
          LineSeries<PortfolioHistory, String>(
            dataSource: portfolioHistory, // Data source for the chart.
            xValueMapper: (PortfolioHistory history, _) =>
                history.date, // Mapping the date for the X-axis.
            yValueMapper: (PortfolioHistory history, _) =>
                history.price, // Mapping the price for the Y-axis.
            name: "Price", // Name of the series.
            // The color of each point in the line chart is determined by the price change.
            pointColorMapper: (PortfolioHistory history, _) {
              int index = portfolioHistory.indexOf(history);
              if (index == 0 ||
                  portfolioHistory[index].price <
                      portfolioHistory[index - 1].price) {
                return Colors.red; // Red for price decrease.
              } else {
                return Colors.green; // Green for price increase.
              }
            },
          ),
        ],
      ),
      // Expanded widget with a SfSparkLineChart to show the same data in a condensed form.
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfSparkLineChart.custom(
            trackball: const SparkChartTrackball(
                activationMode: SparkChartActivationMode.tap),
            marker: const SparkChartMarker(
                displayMode: SparkChartMarkerDisplayMode.all),
            labelDisplayMode: SparkChartLabelDisplayMode.all,
            xValueMapper: (int index) => portfolioHistory[index]
                .date, // Mapping the date for the X-axis.
            yValueMapper: (int index) => portfolioHistory[index]
                .price, // Mapping the price for the Y-axis.
          ),
        ),
      ),
    ],
  );
}
