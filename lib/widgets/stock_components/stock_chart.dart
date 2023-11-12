import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/stock_history.dart'; // Import the StockHistory model
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

Widget buildStockChart(
  List<StockHistory> stockHistries
  ) {
  return Column(
    children: [
      SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: ''),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<StockHistory, String>> [
          LineSeries<StockHistory, String>(
            dataSource: stockHistries,
            xValueMapper: (StockHistory stockHistory, _) => stockHistory.date,
            yValueMapper: (StockHistory stockHistory, _) => stockHistory.price,
            name: "price",
            dataLabelSettings: DataLabelSettings(isVisible: true)
          ),
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfSparkLineChart.custom(
            trackball: SparkChartTrackball(
              activationMode: SparkChartActivationMode.tap
            ),
            marker: SparkChartMarker(
              displayMode: SparkChartMarkerDisplayMode.all
            ),
            labelDisplayMode: SparkChartLabelDisplayMode.all,
            xValueMapper: (int index) => stockHistries[index].date,
            yValueMapper: (int index) => stockHistries[index].price,
          ),
        ),
      )
    ],
  );
}
