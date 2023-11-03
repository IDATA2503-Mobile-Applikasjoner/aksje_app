class StockList {
  final int lid;
  final String name;
  final List<String> stocks;
  final bool valid;

  StockList({
    required this.lid,
    required this.name,
    required this.stocks,
    required this.valid,
  });

  factory StockList.fromJson(Map<String, dynamic> json) {
    return StockList(
      lid: json['lid'] as int,
      name: json['name'] as String,
      stocks: List<String>.from(json['stocks']),
      valid: json['valid'] as bool,
    );
  }
}