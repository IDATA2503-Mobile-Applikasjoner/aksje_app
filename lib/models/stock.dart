//Represent a stock
import 'package:aksje_app/models/stock_history.dart';

class Stock {
  int id;
  String symbol;
  String name;
  double currentPrice;
  double openingPrice;
  double percentChangeIntraday;

  Stock({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.openingPrice,
    required this.percentChangeIntraday,
  });

  //Translate json data to stock
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] as int,
      name: json['name'] as String,
      currentPrice: json['currentPrice'] as double,
      openingPrice: json['openingPrice'] as double,
      percentChangeIntraday: json['percentChangeIntraday'] as double,
      symbol: json['symbol'] as String
    );
  }
}
