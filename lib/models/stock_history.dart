class StockHistory {
  final int shid;
  final String date;
  final double price;

  StockHistory({required this.shid, required this.date, required this.price});

  // Factory constructor to create a StockHistory instance from JSON
  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      shid: json['shid'] as int,
      date: json['date'] as String,
      price: json['price'] as double,
    );
  }
}
