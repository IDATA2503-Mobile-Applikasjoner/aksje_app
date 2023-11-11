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
import 'package:aksje_app/models/stock_purchease.dart';

class StockDetailPage extends StatefulWidget {
  final Stock stock;

  const StockDetailPage({Key? key, required this.stock}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  List<StockListModel> stockLists = [];
  late Stock stock = widget.stock;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 30), (timer) async {
      Stock newStock = await _getStockDataFromServer();
      setState(() {
        stock = newStock;
      });
    });
  }

  void _fetcListDataFromServer() async {
    try {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        var uid = userProvider.user!.uid;
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/listsbyuid/$uid");
        var response = await http.get(baseURL);

        if (response.statusCode == 200) {
          List responseData = jsonDecode(response.body);
          setState(() {
            stockLists = responseData.map((data) => StockListModel.fromJson(data)).toList();
          });
          _showAddToListDialog();
        }
      } catch (e) {
        print(e);
      }
    }

    void _addStockToListInServer(var lid) async {
      try {
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/addStock/$lid");
        var body = jsonEncode(
          {
            "id": widget.stock.id
          }
        );
        var response = await http.post(
          baseURL,
          headers: <String, String> {
            'Content-Type':'application/json; charset=UTF-8',
          },
          body: body,
        );
        if(response.statusCode == 200) {
          print("Stock was added to list");
        }
      }catch(e) {
        print(e);
      }
    }

    void _buyStockAndAddToServer() async {
      try {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        var uid = userProvider.user!.uid;
        DateTime date = DateTime.now();
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/stockpurchease");
        var body = jsonEncode(
          {
            "date": date.toIso8601String(),
            "price": widget.stock.currentPrice,
            "quantity": 1,
            "stock": {
              "id": widget.stock.id
            },
            "portfolio": {
              "pid":uid
            }
          }
        );
        var response = await http.post(
          baseURL,
          headers: <String, String> {
            'Content-Type':'application/json; charset=UTF-8',
          },
          body: body,
        );
        if(response.statusCode == 201) {
          print("stock purchase was created.");
          _showFloatingFlushbarByStock(context);
        }
        else {
          print("Fail creating stock pruchase");
        }
      }catch(e) {
        print(e);
      }
    }

    Future<Stock> _getStockDataFromServer() async {
      try {
        var id = widget.stock.id;
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks/$id");
        var response = await http.get(baseURL);

        if(response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          var newStock = Stock.fromJson(responseData);
          return newStock;
        }
        
        // Return a rejected Future with an error message
        return Future.error("Failed to fetch stock data. Status code: ${response.statusCode}");
      } catch (e) {
        print(e);
        
        // Return a rejected Future with the exception message
        return Future.error("Error occurred while fetching stock data: $e");
      }
    }

    Future<List<Stock>> _getPrucheasStockStocksFromServer() async {
      try {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        var uid = userProvider.user!.uid;
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/portfolio/stocks/$uid");
        var response = await http.get(baseURL);

        if(response.statusCode == 200) {
          List responseData = jsonDecode(response.body);
          List<Stock> stocks = responseData.map((data) => Stock.fromJson(data)).toList();
          return stocks;
        }
        return Future.error("error geting stocks");
      }catch(e) {
        return Future.error("error geting stocks");
      }
    }

    Future<bool> _checkIfUserOwnStock() async {
      var stocks = await _getPrucheasStockStocksFromServer();
      var stock = await _getStockDataFromServer();
      for(Stock stockCheck in stocks) {
        if(stock.id == stockCheck.id) {
          return true;
        }
      }
      return false;
    }

    Future<StockPurchase> _getPrucheasStockFromServer() async {
      try {
        var id = stock.id;
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/stockpurchease/$id/stockpurchease");
        var response = await http.get(baseURL);

        if(response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
         print(responseData);
          var stockPurchease = StockPurchase.fromJson(responseData);
          return stockPurchease;
        }
        return Future.error("error geting stockPurchease");
      }catch (e) {
        print("Error during deserialization: $e");
        return Future.error("error geting stockPurchease");
      }
    }

    Future<void> _removeStockPruch() async {
      try {
        StockPurchase stockPurchease = await _getPrucheasStockFromServer();
        var spid = stockPurchease.spid;
        var baseURL = Uri.parse("http://10.0.2.2:8080/api/stockpurchease/$spid");
        var response = await http.delete(baseURL);
        
        if(response.statusCode == 200) {
          print("stock purcheas was removed");
        }
      }catch (e) {
        return Future.error("error removeing stocks prucheas");
      }
    }

    void _showFloatingFlushbarSelStockTrue(BuildContext context) {
      Flushbar(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundGradient: const LinearGradient(
          colors: [Color.fromARGB(255, 38, 104, 35), Color.fromARGB(255, 45, 143, 0)],
          stops: [0.6, 1],
        ),
        boxShadows: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        title: 'Info',
        message: 'This is not an real stock app, so no payment function is added. The stock was removed from pruch. You can se the stock is no loger in Your stocks in Inventory',
        margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
        flushbarPosition: FlushbarPosition.TOP, 
        duration: const Duration(seconds: 6),
      ).show(context);
    }

    void _showFloatingFlushbarSelStockFalse(BuildContext context) {
      Flushbar(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundGradient: const LinearGradient(
          colors: [Color.fromARGB(255, 175, 25, 25), Color.fromARGB(255, 233, 0, 0)],
          stops: [0.6, 1],
        ),
        boxShadows: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        title: 'Info',
        message: 'You dont own this stock',
        margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
        flushbarPosition: FlushbarPosition.TOP, 
        duration: const Duration(seconds: 6),
      ).show(context);
    }
    

    void _showFloatingFlushbarByStock(BuildContext context) {
      Flushbar(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(8),
        backgroundGradient: const LinearGradient(
          colors: [Color.fromARGB(255, 38, 104, 35), Color.fromARGB(255, 45, 143, 0)],
          stops: [0.6, 1],
        ),
        boxShadows: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        title: 'Info',
        message: 'This is not an real stock app, so no payment function is added. The stock has been added as a pruch, you can see the stock in your stocks at Inventory.',
        margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
        flushbarPosition: FlushbarPosition.TOP, 
        duration: const Duration(seconds: 6),
      ).show(context);
    }

    void _showAddToListDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select a List'),
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

    Future<void> _onRefresh() async {
      try {
        Stock newStock = await _getStockDataFromServer();
        setState(() {
          stock = newStock;
        });
      } catch (error) {
        // Handle errors appropriately (e.g., show an error message).
        print("Error refreshing data: $error");
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
                    _fetcListDataFromServer();
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
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${stock.currentPrice.toString()} NOK (${stock.percentChangeIntraday.toString()}%)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 300,
                      child: StockChart(),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _buyStockAndAddToServer();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 79, 117, 205),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
                          ),
                          child: const Text('Buy'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if( await _checkIfUserOwnStock()) {
                              await _removeStockPruch();
                              _showFloatingFlushbarSelStockTrue(context);
                            }
                            else {
                              _showFloatingFlushbarSelStockFalse(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 185, 56, 47),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
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