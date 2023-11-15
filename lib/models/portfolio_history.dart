class PortfolioHistory {
  final int phid;
  final String date;
  final double price;

  PortfolioHistory({required this.phid, required this.date, required this.price});

  // Factory constructor to create a StockHistory instance from JSON
  factory PortfolioHistory.fromJson(Map<String, dynamic> json) {
    return PortfolioHistory(
      phid: json['phid'] as int,
      date: json['date'] as String,
      price: json['price'] as double,
    );
  }
}
