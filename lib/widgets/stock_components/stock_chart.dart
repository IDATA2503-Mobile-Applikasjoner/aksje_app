import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/models/stock_history.dart'; // Import the StockHistory model

class StockChart extends StatefulWidget {
  final StockHistory stock;

  const StockChart({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the stock's historical data as the data source for the chart
    List<StockHistory> chartData =
        stock.shid as List<StockHistory>; // Assuming 'stock.history' is a List<StockHistory>

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <LineSeries<StockHistory, DateTime>>[
        LineSeries<StockHistory, DateTime>(
          dataSource: chartData,
          xValueMapper: (StockHistory data, _) => data.time,
          yValueMapper: (StockHistory data, _) => data.price,
        )
      ],
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
