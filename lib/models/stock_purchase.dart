/// Represents a single stock purchase transaction.
class StockPurchase {
  /// Unique identifier for the stock purchase.
  late int spid;

  /// Date of the stock purchase.
  late DateTime date;

  /// Purchase price of the stock.
  late double price;

  /// Quantity of stocks purchased.
  late int quantity;

  /// Constructs a [StockPurchase] with a given [spid], [date], [price], and [quantity].
  StockPurchase({
    required this.spid,
    required this.date,
    required this.price,
    required this.quantity,
  });

  /// Creates a [StockPurchase] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'spid', 'date', 'price', and 'quantity'.
  /// The 'date' is parsed to a DateTime object.
  factory StockPurchase.fromJson(Map<String, dynamic> json) {
    return StockPurchase(
      spid: json['spid'] as int,
      date: DateTime.parse(json['date']),
      price: json['price'] as double,
      quantity: json['quantity'] as int,
    );
  }
}
