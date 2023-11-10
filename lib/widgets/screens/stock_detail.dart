import 'package:aksje_app/models/stock_list_model.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StockDetailPage extends StatefulWidget {
  final Stock stock;

  const StockDetailPage({Key? key, required this.stock}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  List<StockListModel> stockLists = [];

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
      body: SingleChildScrollView(
        child: Padding(
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
                '${widget.stock.symbol} ${widget.stock.name}',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.stock.currentPrice.toString()} NOK (${widget.stock.percentChangeIntraday.toString()}%)',
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
                      // Logic for buying the stock goes here.
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
                    onPressed: () {
                      // Logic for selling the stock goes here.
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
      ),
    );
  }
}