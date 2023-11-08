import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_list_components/stock_list_item.dart';

class StockListModelList extends StatelessWidget {
  final List<StockListModel> stockLists;

  const StockListModelList({
    Key? key,
    required this.stockLists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stockLists.length,
      itemBuilder: (ctx, index) {
        return StockListItem(stockList: stockLists[index]);
      },
    );
  }
}