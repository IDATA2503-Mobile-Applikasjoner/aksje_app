class StockHistory {
  final String shid;
  final DateTime time;
  final double price;

  StockHistory({required this.shid, required this.time, required this.price});

  // Factory constructor to create a StockHistory instance from JSON
  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      shid: json['shid'] as String,
      time: DateTime.parse(json['time'] as String),
      price: json['price'] as double,
    );
  }
}
