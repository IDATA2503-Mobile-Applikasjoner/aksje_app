/// Represents a model of a stock list.
class StockListModel {
  /// Unique identifier for the stock list.
  final int lid;

  /// Name of the stock list.
  final String name;

  /// Collection of stocks, each represented as a map of string to dynamic values.
  final List<Map<String, dynamic>> stocks;

  /// Indicates whether the stock list is valid.
  final bool valid;

  /// Constructs a [StockListModel] with a given [lid], [name], [stocks], and [valid] status.
  StockListModel({
    required this.lid,
    required this.name,
    required this.stocks,
    required this.valid,
  });

  /// Creates a [StockListModel] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'lid', 'name', 'stocks', and 'valid'.
  /// 'stocks' is expected to be a list of maps with string keys and dynamic values.
  factory StockListModel.fromJson(Map<String, dynamic> json) {
    return StockListModel(
      lid: json['lid'] as int,
      name: json['name'] as String,
      stocks: List<Map<String, dynamic>>.from(json['stocks']),
      valid: json['valid'] as bool,
    );
  }
}
