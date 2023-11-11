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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fectStocskDataFromServer();
  }

  void _fectStocskDataFromServer() async {
    try {
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        setState(() {
          List responseData = jsonDecode(response.body);
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
          filteredStocks = List.from(stocks);
          isLoading = false; // Set loading to false when data is loaded
        });
      }
    } catch (e) {
      print(e);
      isLoading = false; // Set loading to false if an error occurs
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

  void _goToStockDetailPage(Stock stock) async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stock1 = Stock.fromJson(responseData);
        _navToStockDetailPage(stock1);
      }
    } catch (e) {
      print(e);
    }
  }

  void _navToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

    Future<void> _onRefresh() async {
    setState(() {
      _fectStocskDataFromServer();
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : StockList(
                      stocks: filteredStocks,
                      onStockTap: (stock) => _goToStockDetailPage(stock),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}