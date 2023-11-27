import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_list_components/stock_list_item.dart';

/// A widget that displays a list of stock list models.
///
/// This stateless widget generates a scrollable list of stock list items.
/// Each item represents a stock list and can trigger a specified action when tapped.
class StockListModelList extends StatelessWidget {
  final List<StockListModel> stockLists;
  final Function(StockListModel) onStockListTap;

  /// Constructs a StockListModelList widget.
  ///
  /// [stockLists] is a list of StockListModel objects to be displayed.
  /// [onStockListTap] is a function that will be called when an item in the list is tapped.
  const StockListModelList(
      {Key? key, required this.stockLists, required this.onStockListTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stockLists.length,
      itemBuilder: (ctx, index) {
        // Creates a StockListItem for each stock list in the provided list.
        // Passes the current stock list and the tap handler to each item.
        return StockListItem(
            stockList: stockLists[index], onStockListTap: onStockListTap);
      },
    );
  }
}
