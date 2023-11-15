import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/portfolio_history.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

Widget buildStockChartInventory(List<PortfolioHistory> portfolioHistory) {
  return Column(
    children: [
      SfCartesianChart(
        primaryXAxis: CategoryAxis(),
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
            dataSource: portfolioHistory,
            xValueMapper: (PortfolioHistory portfolioHistory, _) => portfolioHistory.date,
            yValueMapper: (PortfolioHistory portfolioHistory, _) => portfolioHistory.price,
            name: "Price",
            pointColorMapper: (PortfolioHistory stockHistory, _) {
              int index = portfolioHistory.indexOf(stockHistory);
              if (index == 0 ||
                  portfolioHistory[index].price <
                      portfolioHistory[index - 1].price) {
                return Colors.red;
              } else {
                return Colors.green;
              }
            },
          ),
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfSparkLineChart.custom(
            trackball: const SparkChartTrackball(
                activationMode: SparkChartActivationMode.tap),
            marker: const SparkChartMarker(
                displayMode: SparkChartMarkerDisplayMode.all),
            labelDisplayMode: SparkChartLabelDisplayMode.all,
            xValueMapper: (int index) => portfolioHistory[index].date,
            yValueMapper: (int index) => portfolioHistory[index].price,
          ),
        ),
      ),
    ],
  );
}
