/// Represents the historical data of a stock.
class StockHistory {
  /// Date of the stock price record.
  final DateTime date;

  final double open;

  final double close;

  final double high;

  final double low;

  /// Constructs a [StockHistory] instance with a given [shid], [date], and [price].
  StockHistory({
    required this.open,
    required this.date,
    required this.close,
    required this.high,
    required this.low,
  });

  /// Creates a [StockHistory] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'shid', 'date', and 'price'.
  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      date: DateTime.parse(json['date']),
      open: json['open'] as double,
      close: json['close'] as double,
      high: json['high'] as double,
      low: json['low'] as double,
    );
  }
}
