
class StockPurchase {
  late int spid;
  late DateTime date;
  late double price;
  late int quantity;

  StockPurchase({
    required this.spid,
    required this.date,
    required this.price,
    required this.quantity,
  });

  factory StockPurchase.fromJson(Map<String, dynamic> json) {
    return StockPurchase(
      spid: json['spid'] as int ,
      date: DateTime.parse(json['date']),
      price: json['price'] as double,
      quantity: json['quantity'] as int,
    );
  }
}