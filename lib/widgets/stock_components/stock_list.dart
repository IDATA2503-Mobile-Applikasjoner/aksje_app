import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_item.dart';
import 'package:flutter/material.dart';

/// A widget that displays a list of stocks in a scrollable view.
///
/// This stateless widget creates a list of stock items, each representing a stock.
/// It supports tap actions on each stock item and optionally enables a swipe-to-delete feature.
class StockList extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock) onStockTap;
  final bool isDeleteEnabled;

  /// Constructs a StockList widget.
  ///
  /// [stocks] is a list of Stock objects to be displayed.
  /// [onStockTap] is a function to be called when a stock item is tapped.
  /// [isDeleteEnabled] specifies whether the swipe-to-delete feature is enabled.
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
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  // Remove the stock from the list when swiped away.
                  stocks.removeAt(index);
                },
                child: StockItem(stock: stocks[index]),
              )
            : StockItem(stock: stocks[index]),
      ),
    );
  }
}
