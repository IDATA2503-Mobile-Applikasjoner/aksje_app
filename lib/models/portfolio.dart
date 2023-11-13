import 'package:aksje_app/models/user.dart';
import 'package:aksje_app/models/stock_purchase.dart';

/// Represents a user's stock portfolio.
class Portfolio {
  /// Unique identifier for the portfolio.
  late int pid;

  /// User associated with the portfolio.
  late User user;

  /// Collection of stock purchases in the portfolio.
  late Set<StockPurchase> stockPurchases;

  /// Constructs a portfolio with a given [pid], [user], and [stockPurchases].
  Portfolio({
    required this.pid,
    required this.user,
    required this.stockPurchases,
  });

  /// Creates a [Portfolio] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'pid', 'user', and 'stockPurchases'.
  /// 'user' and 'stockPurchases' are converted from JSON using respective model classes.
  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      pid: json['pid'] as int,
      user: User.fromJson(json['user']),
      stockPurchases: (json['stockPurchases'] as List<dynamic>)
          .map((purchase) => StockPurchase.fromJson(purchase))
          .toSet(),
    );
  }
}
