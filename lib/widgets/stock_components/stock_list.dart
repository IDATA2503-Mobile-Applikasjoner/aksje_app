import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_item.dart';
import 'package:flutter/material.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock) onStockTap;
  final bool isDeleteEnabled;

  const StockList({
    Key? key,
    required this.stocks,
    required this.onStockTap,
    required this.isDeleteEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onStockTap(stocks[index]);
        },
        child: isDeleteEnabled
            ? Dismissible(
                key: ValueKey(stocks[index].id),
                background: Container(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onDismissed: (direction) {
                  // Remove the stock from the list when dismissed
                  stocks.removeAt(index);
                },
                child: StockItem(stock: stocks[index]),
              )
            : StockItem(stock: stocks[index]),
      ),
    );
  }
}