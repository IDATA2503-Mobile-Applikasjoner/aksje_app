import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock_history.dart';
import 'package:candlesticks/candlesticks.dart';

/// Builds a stock chart widget displaying a stock's historical data.
///
/// This function creates a visual representation of the stock's price history
/// using a line chart and a sparkline chart from the Syncfusion Flutter Charts package.
/// It shows the price movement over time, with different colors indicating
/// increases or decreases in price.
///
/// [stockHistories] is a list of StockHistory objects containing the historical data of the stock.
Widget buildStockChart(List<StockHistory> stockHistories) {
  List<Candle> candleHistories = [];

  for (var stockHistory in stockHistories) {
    candleHistories.add(Candle(
        open: stockHistory.open,
        high: stockHistory.high,
        low: stockHistory.low,
        close: stockHistory.close,
        date: stockHistory.date,
        volume: 0));
  }
  return Column(
    children: [
      Candlesticks(candles: candleHistories),
    ],
  );
}
