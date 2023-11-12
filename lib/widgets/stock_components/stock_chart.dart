import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/stock_history.dart'; // Import the StockHistory model
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

Widget buildStockChart(List<StockHistory> stockHistories) {
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
        series: <ChartSeries<StockHistory, String>>[
          LineSeries<StockHistory, String>(
            dataSource: stockHistories,
            xValueMapper: (StockHistory stockHistory, _) => stockHistory.date,
            yValueMapper: (StockHistory stockHistory, _) => stockHistory.price,
            name: "Price",
            pointColorMapper: (StockHistory stockHistory, _) {
              int index = stockHistories.indexOf(stockHistory);
              if (index == 0 ||
                  stockHistories[index].price <
                      stockHistories[index - 1].price) {
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
            xValueMapper: (int index) => stockHistories[index].date,
            yValueMapper: (int index) => stockHistories[index].price,
          ),
        ),
      ),
    ],
  );
}
