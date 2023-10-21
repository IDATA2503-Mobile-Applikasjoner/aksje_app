import 'package:aksje_app/models/stock.dart';

class StockListModel {
  final String id;
  final String name;
  final List<Stock> stocks;

  StockListModel({
    required this.id,
    required this.name,
    required this.stocks,
  });
}
