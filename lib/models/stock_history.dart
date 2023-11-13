/// Represents the historical data of a stock.
class StockHistory {
  /// Unique identifier for the stock history.
  final int shid;

  /// Date of the stock price record.
  final String date;

  /// Price of the stock on the recorded date.
  final double price;

  /// Constructs a [StockHistory] instance with a given [shid], [date], and [price].
  StockHistory({
    required this.shid,
    required this.date,
    required this.price,
  });

  /// Creates a [StockHistory] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'shid', 'date', and 'price'.
  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      shid: json['shid'] as int,
      date: json['date'] as String,
      price: json['price'] as double,
    );
  }
}
