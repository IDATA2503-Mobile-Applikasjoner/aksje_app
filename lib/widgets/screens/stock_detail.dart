import 'package:aksje_app/models/stock_history.dart';
import 'package:aksje_app/models/stock_list_model.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:another_flushbar/flushbar.dart';
import 'dart:async';
import 'package:aksje_app/models/stock_purchase.dart';
import 'package:aksje_app/widgets/components/flush_bar_error.dart';
import 'package:aksje_app/widgets/components/flush_bar.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';

class StockDetailPage extends StatefulWidget {
  final Stock stock;

  const StockDetailPage({Key? key, required this.stock}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  List<StockListModel> stockLists = [];
  late Stock stock = widget.stock;
  late Timer timer;
  late List<StockHistory> stockHistries = [];

  @override
  void initState() {
    _setSTockHistriesWithDataFromServer();
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (mounted) {
        Stock newStock = await _getStockDataFromServer();
        List<StockHistory> newStockHistories =
            await _setSTockHistriesWithDataFromServer();
        setState(() {
          stock = newStock;
          stockHistries = newStockHistories;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Gets the stock lists that the user have from the database.
  Future<List<StockListModel>> _fetcListDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/list/listsbyuid/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<StockListModel> newStockList =
            responseData.map((data) => StockListModel.fromJson(data)).toList();
        return newStockList;
      }
      return Future.error(
          "Failed to fetch stockList data. Status code: ${response.statusCode}");
    } catch (e) {
      return Future.error("Error geting stockLists");
    }
  }

  // Shows all the list that the user have.
  void _showListOptions() async {
    setState(() async {
      stockLists = await _fetcListDataFromServer();
      _showAddToListDialog();
    });
  }

  // Add a stock to a list then saves it in the database.
  Future<void> _addStockToListInServer(var lid) async {
    try {
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/list/addStock/$lid");
      var body = jsonEncode({"id": widget.stock.id});
      var response = await http.post(
        baseURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      if (response.statusCode != 200) {
        return Future.error(
            "Faild to add stock to a list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return Future.error("Fail to add stock to a list.");
    }
  }

  // Creates a stock pruchase then save it in the database.
  Future<bool> _addStockPrchaseToServer() async {
    bool added = false;
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      DateTime date = DateTime.now();
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/stockpurchease");
      var body = jsonEncode({
        "date": date.toIso8601String(),
        "price": widget.stock.currentPrice,
        "quantity": 1,
        "stock": {"id": widget.stock.id},
        "portfolio": {"pid": uid}
      });
      var response = await http.post(
        baseURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      if (response.statusCode == 201) {
        added = true;
        return added;
      }
      return added;
    } catch (e) {
      return Future.error("Fail to added ");
    }
  }

  // checks if the stock is beeing added to the server and shows a Flushbar
  // informing the user that the stock is beeing bought
  void _buyStock() async {
    bool added = await _addStockPrchaseToServer();
    if (added = true) {
      String infoMassage =
          'This is not an real stock app, so no payment function is added. The stock has been added as a pruch, you can see the stock in your stocks at Inventory.';
      buildFlushBarInfo(context, infoMassage, "Info", Color.fromARGB(255, 38, 104, 35),Color.fromARGB(255, 45, 143, 0));
      //_showFloatingFlushbarByStock(context);
    }
  }

  // Gets the stock data from the database, from the stock you are in now.
  // Used to update the stock price for the user.
  Future<Stock> _getStockDataFromServer() async {
    try {
      var id = widget.stock.id;
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newStock = Stock.fromJson(responseData);
        return newStock;
      }
      return Future.error(
          "Failed to fetch stock data. Status code: ${response.statusCode}");
    } catch (e) {
      return Future.error("Error occurred while fetching stock data: $e");
    }
  }

  // Gets the Stock form the pruchsase stocks from the database based on the user.
  Future<List<Stock>> _getPrucheasStockStocksFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/portfolio/stocks/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<Stock> stocks =
            responseData.map((data) => Stock.fromJson(data)).toList();
        return stocks;
      }
      return Future.error("error geting stocks");
    } catch (e) {
      return Future.error("error geting stocks");
    }
  }

  // Checks if the user allredy owns the stock
  //Returns true if the user owns it, false if not.
  Future<bool> _checkIfUserOwnStock() async {
    var stocks = await _getPrucheasStockStocksFromServer();
    var stock = await _getStockDataFromServer();
    for (Stock stockCheck in stocks) {
      if (stock.id == stockCheck.id) {
        return true;
      }
    }
    return false;
  }

  // Gets all stock purcheas from the database.
  Future<StockPurchase> _getPrucheasStockFromServer() async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse(
          "http://10.212.25.216:8080/api/stockpurchease/$id/stockpurchease");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stockPurchease = StockPurchase.fromJson(responseData);
        return stockPurchease;
      }
      return Future.error("error geting stockPurchease");
    } catch (e) {
      return Future.error("error geting stockPurchease");
    }
  }

  Future<List<StockHistory>> _setSTockHistriesWithDataFromServer() async {
    try {
      var id = stock.id;
      var baseURL =
          Uri.parse("http://10.212.25.216:8080/api/stockhistory/stocks/$id");
      var response = await http.get(baseURL);
      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<StockHistory> newStockHistories =
            responseData.map((data) => StockHistory.fromJson(data)).toList();
        setState(() {
          stockHistries = newStockHistories;
        });
        return newStockHistories;
      }
      return Future.error("Didn't get data");
    } catch (e) {
      return Future.error("Didnt get data");
    }
  }

  // Removes a stock purcheas from the database.
  Future<void> _removeStockPruch() async {
    try {
      StockPurchase stockPurchease = await _getPrucheasStockFromServer();
      var spid = stockPurchease.spid;
      var baseURL = Uri.parse("http://10.212.25.216:8080/api/stockpurchease/$spid");
      var response = await http.delete(baseURL);

      if (response.statusCode != 200) {
        return Future.error("error removeing stocks prucheas");
      }
    } catch (e) {
      return Future.error("error removeing stocks prucheas");
    }
  }

  

  // All the list you can add the stock to.
  void _showAddToListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a List'),
          content: SingleChildScrollView(
            child: Column(
              children: stockLists.map((stockList) {
                return ListTile(
                  title: Text(stockList.name),
                  onTap: () {
                    _addStockToListInServer(stockList.lid);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Refreshes the data on the page.
  Future<void> _onRefresh() async {
    try {
      Stock newStock = await _getStockDataFromServer();
      setState(() {
        stock = newStock;
      });
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(selectedIndex: 2),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Add to List':
                  _showListOptions();
                  break;
                case 'Add to Live Activity':
                  // Logic to add stock to live activity goes here.
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Add to List',
                child: Text('Add to List'),
              ),
              const PopupMenuItem<String>(
                value: 'Add to Live Activity',
                child: Text('Add to Live Activity'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Oslo Børs Open',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${stock.symbol} ${stock.name}',
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the row takes the minimum space needed
                    children: [
                      Text(
                        '${stock.currentPrice.toString()} NOK ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${stock.percentChangeIntraday.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: stock.percentChangeIntraday >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        stock.percentChangeIntraday >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: stock.percentChangeIntraday >= 0
                            ? Colors.green
                            : Colors.red,
                        size: 16, // Adjust the icon size as needed
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: buildStockChart(stockHistries),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!await _checkIfUserOwnStock()) {
                            _buyStock();
                          } else {
                            String errorMassage =
                                "User already owns this stock";
                            buildFlushBarError(context, errorMassage);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 79, 117, 205),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 62, vertical: 16),
                        ),
                        child: const Text('Buy'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (await _checkIfUserOwnStock()) {
                            await _removeStockPruch();
                            String infoMassage =
                                'This is not an real stock app, so no payment function is added. The stock was removed from pruch. You can se the stock is no loger in Your stocks in Inventory';
                            buildFlushBarInfo(context, infoMassage, "Info", Color.fromARGB(255, 38, 104, 35), Color.fromARGB(255, 45, 143, 0));
                          } else {
                            String errorMassage = 'You dont own this stock.';
                            buildFlushBarError(context, errorMassage);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 185, 56, 47),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 62, vertical: 16),
                        ),
                        child: const Text('Sell'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
