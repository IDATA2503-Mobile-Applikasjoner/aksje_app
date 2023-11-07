import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_item.dart';
import 'package:flutter/material.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock) onStockTap;

  const StockList({
    Key? key,
    required this.stocks,
    required this.onStockTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onStockTap(stocks[index]);
        },
        child: Dismissible(
          key: ValueKey(stocks[index].id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: StockItem(stock: stocks[index]),
        ),
      ),
    );
  }
}