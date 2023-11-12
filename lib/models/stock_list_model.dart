//Represent Stock list 
class StockListModel {
  final int lid;
  final String name;
  final List<Map<String, dynamic>> stocks; // Update the type of stocks to match the JSON structure
  final bool valid;

  StockListModel({
    required this.lid,
    required this.name,
    required this.stocks,
    required this.valid,
  });

  //Translate json datat to a stock list.
  factory StockListModel.fromJson(Map<String, dynamic> json) {
    return StockListModel(
      lid: json['lid'] as int,
      name: json['name'] as String,
      stocks: List<Map<String, dynamic>>.from(json['stocks']), // Adjust the type of stocks
      valid: json['valid'] as bool,
    );
  }
}