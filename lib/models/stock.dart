import 'package:aksje_app/models/stock_history.dart';

/// Represents details of a stock.
class Stock {
  /// Unique identifier for the stock.
  int id;

  /// Trading symbol of the stock.
  String symbol;

  /// Name of the stock or company.
  String name;

  /// Current trading price of the stock.
  double currentPrice;

  /// Opening price of the stock for the current trading day.
  double openingPrice;

  /// Percentage change in stock price intraday.
  double percentChangeIntraday;

  /// Constructs a [Stock] with a given [id], [symbol], [name], [currentPrice],
  /// [openingPrice], and [percentChangeIntraday].
  Stock({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.openingPrice,
    required this.percentChangeIntraday,
  });

  /// Creates a [Stock] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'id', 'symbol', 'name', 'currentPrice',
  /// 'openingPrice', and 'percentChangeIntraday'.
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] as int,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      currentPrice: json['currentPrice'] as double,
      openingPrice: json['openingPrice'] as double,
      percentChangeIntraday: json['percentChangeIntraday'] as double,
    );
  }
}
