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
import 'dart:async';
import 'package:aksje_app/models/stock_purchase.dart';
import 'package:aksje_app/widgets/components/flush_bar.dart';
import '../../globals.dart' as globals;

/// A detailed page displaying a specific stock's information.
///
/// This page shows detailed information about a given stock, including its history and options
/// to add it to a user's list or make a purchase. It regularly updates the stock data from the server.
class StockDetailPage extends StatefulWidget {
  final Stock stock;

  /// Constructs a [StockDetailPage] widget with the required [stock] parameter.
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
    super.initState();
    _setStockHistoriesWithDataFromServer();
    // Sets a timer to periodically update stock data from the server.
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (mounted) {
        Stock newStock = await _getStockDataFromServer();
        List<StockHistory> newStockHistories =
            await _setStockHistoriesWithDataFromServer();
        setState(() {
          stock = newStock;
          stockHistries = newStockHistories;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancels the timer when the widget is disposed to prevent memory leaks.
    timer.cancel();
    super.dispose();
  }

  /// Fetches the list of stocks that the user has from the server.
  ///
  /// Returns a list of [StockListModel] representing the user's stock lists.
  Future<List<StockListModel>> _fetcListDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("${globals.baseUrl}/api/list/listsbyuid/$uid");
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
      return Future.error("Error getting stockLists");
    }
  }

  /// Displays options for the user to add a stock to their list.
  ///
  /// Fetches the user's stock lists and shows a dialog for adding the stock to a list.
  void _showListOptions() async {
    setState(() async {
      stockLists = await _fetcListDataFromServer();
      _showAddToListDialog();
    });
  }

  /// Adds a stock to a list on the server.
  ///
  /// Takes the list ID [lid] as a parameter and sends a request to the server to add the stock to the specified list.
  Future<void> _addStockToListInServer(var lid) async {
    try {
      var baseURL = Uri.parse("${globals.baseUrl}/api/list/addStock/$lid");
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
            "Failed to add stock to a list. Status code: ${response.statusCode}");
      }
    } catch (e) {
      return Future.error("Failed to add stock to a list.");
    }
  }

  /// Adds a stock purchase to the server and saves it in the database.
  ///
  /// It creates a POST request with the current stock data and user's portfolio
  /// information and sends it to the server. If the server responds with a status
  /// code of 201, the function returns true, indicating the stock was successfully added.
  Future<bool> _addStockPrchaseToServer() async {
    bool added = false;
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      DateTime date = DateTime.now();
      var baseURL = Uri.parse("${globals.baseUrl}/api/stockpurchease");
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
      }
      return added;
    } catch (e) {
      return Future.error("Failed to add stock: $e");
    }
  }

  /// Initiates the stock purchase process and displays a notification to the user.
  ///
  /// Calls [_addStockPrchaseToServer] to add the stock purchase to the server.
  /// If the stock is successfully added, it displays a message using Flushbar to
  /// inform the user that the stock has been purchased.
  void _buyStock() async {
    bool added = await _addStockPrchaseToServer();
    if (added) {
      String infoMessage =
          'This is not a real stock app, so no payment function is added. The stock has been added as a purchase, you can see the stock in your stocks at Inventory.';
      buildFlushBar(
          context,
          infoMessage,
          "Info",
          const Color.fromARGB(255, 38, 104, 35),
          const Color.fromARGB(255, 45, 143, 0));
    }
  }

  /// Retrieves the current stock data from the server.
  ///
  /// Sends a GET request to the server to fetch the latest data for the current stock.
  /// Returns a `Stock` object with the updated data if successful, otherwise throws an error.
  Future<Stock> _getStockDataFromServer() async {
    try {
      var id = widget.stock.id;
      var baseURL = Uri.parse("${globals.baseUrl}/api/stocks/$id");
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

  /// Fetches purchased stocks from the server for the current user.
  ///
  /// Sends a GET request to retrieve all stocks purchased by the user.
  /// Returns a list of `Stock` objects if successful, otherwise throws an error.
  Future<List<Stock>> _getPrucheasStockStocksFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("${globals.baseUrl}/api/portfolio/stocks/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<Stock> stocks =
            responseData.map((data) => Stock.fromJson(data)).toList();
        return stocks;
      }
      return Future.error("Error getting stocks");
    } catch (e) {
      return Future.error("Error getting stocks: $e");
    }
  }

  /// Checks if the user already owns the specified stock.
  ///
  /// Retrieves the list of stocks purchased by the user and the current stock's data.
  /// Compares the IDs of each purchased stock with the current stock's ID.
  /// Returns `true` if a match is found (the user owns the stock), otherwise `false`.
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

  /// Retrieves a specific stock purchase from the server.
  ///
  /// Sends a GET request to fetch details of a particular stock purchase using its ID.
  /// If successful, returns a `StockPurchase` object with the retrieved data.
  /// Throws an error if the request fails or if the server response is not successful.
  Future<StockPurchase> _getPrucheasStockFromServer() async {
    try {
      var id = stock.id;
      var baseURL =
          Uri.parse("${globals.baseUrl}/api/stockpurchease/$id/stockpurchease");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stockPurchease = StockPurchase.fromJson(responseData);
        return stockPurchease;
      }
      return Future.error("Error getting stock purchase");
    } catch (e) {
      return Future.error("Error getting stock purchase: $e");
    }
  }

  /// Fetches and sets the stock history data from the server.
  ///
  /// Sends a GET request to retrieve the history of a specific stock using its ID.
  /// Updates the `stockHistries` state with the new data if the request is successful.
  /// Returns a list of `StockHistory` objects or throws an error if the request fails.
  Future<List<StockHistory>> _setStockHistoriesWithDataFromServer() async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse(
          "${globals.baseUrl}/api/stockhistory/stocks/candleStick/$id");
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
      return Future.error("Failed to retrieve stock history data");
    } catch (e) {
      return Future.error("Failed to retrieve stock history data: $e");
    }
  }

  /// Removes a stock purchase from the database.
  ///
  /// Retrieves the details of a specific stock purchase and sends a DELETE request
  /// to remove it from the server using its specific ID.
  /// Throws an error if the deletion is not successful or if the request fails.
  Future<void> _removeStockPurchase() async {
    try {
      UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("${globals.baseUrl}/api/stockpurchease/$uid");
      var responds = await http.delete(
        baseURL,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {
          "id": widget.stock.id,
        }
      );
      if(responds.statusCode == 404) {
        var errorMassage = responds.body;
        buildFlushBar(context, "You don't own this stock.", "warning", const Color.fromARGB(255, 175, 25, 25), const Color.fromARGB(255, 233, 0, 0));
      }
    } catch (e) {
      return Future.error("Error removing stock purchase: $e");
    }
  }

  /// Displays a dialog allowing the user to add the stock to one of their lists.
  ///
  /// Opens an AlertDialog displaying a list of available stock lists.
  /// When a list is selected, [_addStockToListInServer] is called with the selected list's ID,
  /// and the dialog is closed.
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

  /// Refreshes the stock data displayed on the page.
  ///
  /// Calls [_getStockDataFromServer] to fetch the latest stock data and updates the UI.
  /// If the data retrieval fails, an error is returned.
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
                    mainAxisSize: MainAxisSize.min,
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
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: //const Text("halla"),
                        buildStockChart(stockHistries),
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
                            buildFlushBar(
                                context,
                                errorMassage,
                                "Error",
                                const Color.fromARGB(255, 175, 25, 25),
                                const Color.fromARGB(255, 233, 0, 0));
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
                          await _removeStockPurchase();
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
