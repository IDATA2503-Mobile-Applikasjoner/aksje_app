import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_list.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];

  @override
  void initState() {
    super.initState();
    _fectStockDataFromServer();
  }

  void _fectStockDataFromServer() async {
    try {
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        setState(() {
          List responseData = jsonDecode(response.body);
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
          filteredStocks = List.from(stocks);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _filterStocks(String query) {
    setState(() {
      filteredStocks = stocks
          .where((stock) =>
              stock.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

    void _goToStockDetailPage(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterStocks(value);
              },
            ),
          ),
          Expanded(
              child: StockList(
              stocks: filteredStocks,
              onStockTap: (stock) => _goToStockDetailPage(stock),
            ),
          ),
        ],
      ),
    );
  }
}