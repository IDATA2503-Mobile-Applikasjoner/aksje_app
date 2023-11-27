import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_components/stock_list.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import 'dart:async';

//The A list page
//Contis the list and what stock the user have in that list.
class StockWatchlistPage extends StatefulWidget {
  final StockListModel stockList;
  const StockWatchlistPage({super.key, required this.stockList});

  @override
  _StockWatchlistPageState createState() => _StockWatchlistPageState();
}

class _StockWatchlistPageState extends State<StockWatchlistPage> {
  List<Stock> stocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setStocksData();

    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _setStocksData();
      });
    });
  }

  // Gets the stocks data from the server
  Future<List<Stock>> _fetchStocksDataFromServer() async {
    try {
      var lid = widget.stockList.lid;
      var baseURL =
          Uri.parse("http://10.212.25.216:8080/api/stocks/lists/$lid/stocks");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<Stock> stocksData =
            responseData.map((data) => Stock.fromJson(data)).toList();
        return stocksData;
      }
      return Future.error("Didn't find stock data");
    } catch (e) {
      return Future.error(e);
    }
  }

  //Sets the stock data to the stocks list
  void _setStocksData() async {
    List<Stock> newStocks = await _fetchStocksDataFromServer();
    setState(() {
      isLoading = false;
      stocks = newStocks;
    });
  }

  //Get the stock data form the server
  Future<Stock> _getStockDataFromnServer(Stock stock) async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newStock = Stock.fromJson(responseData);
        return newStock;
      }
      return Future.error("Didn't find stock");
    } catch (e) {
      return Future.error(e);
    }
  }

  //Gose to stock detail page based on the data of the stock from the database.
  void _goToStockDetailPage(Stock stock) async {
    Stock serverStock = await _getStockDataFromnServer(stock);
    _navToStockDetailPage(serverStock);
  }

  //Naviagtest to stock detail page.
  void _navToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  //Refreshes the page with new data.
  Future<void> _onRefresh() async {
    setState(() {
      _setStocksData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.stockList.name),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(selectedIndex: 1),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: <Widget>[
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : StockList(
                        stocks: stocks,
                        onStockTap: (stock) => _goToStockDetailPage(stock),
                        isDeleteEnabled: true,
                      ),
              ),
            ],
          ),
        ));
  }
}
