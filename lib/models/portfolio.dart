import 'dart:convert';
import 'package:aksje_app/models/user.dart';
import 'package:aksje_app/models/stock_purchease.dart';

class Portfolio {
  late int pid;
  late User user;
  late Set<StockPurchase> stockPurchases;

  Portfolio({
    required this.pid,
    required this.user,
    required this.stockPurchases,
  });

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