import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_list_components/stock_list_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/add_list.dart';
import 'package:aksje_app/models/user.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/widgets/screens/stock_watchlist_page.dart';

//Represent my list page.
//User can see what list he has.
class MyListsPage extends StatefulWidget {
  const MyListsPage({Key? key}) : super(key: key);

  @override
  _MyListsPageState createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  List<StockListModel> lists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDataFromServer();
  }

  //Gets stock list data from the server and sets the lists to that data.
  Future<void> _fetchDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/listsbyuid/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          lists = responseData
              .map((data) => StockListModel.fromJson(data))
              .toList();
          isLoading = false;
        });
      } else {
        Future.error('Request failed with status: ${response.statusCode}.');
        isLoading = false;
      }
    } catch (e) {
      Future.error(e);
      isLoading = false;
    }
  }

  //Navigates to add list page
  void _navToAddListPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AddListPage(),
        ));
  }

  //Get list from database and navigates to that list.
  Future<void> _goTiListPageWithDataFromServer(
      StockListModel stockListModel) async {
    try {
      var lid = stockListModel.lid;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/$lid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stockList = StockListModel.fromJson(responseData);
        _navToListPage(stockList);
      }
    } catch (e) {
      print(e);
    }
  }

  //Navigates to list page.
  void _navToListPage(StockListModel stockListModel) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StockWatchlistPage(stockList: stockListModel)));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          IconButton(
              onPressed: _navToAddListPage,
              icon: const Icon(Icons.add_outlined)),
        ],
      ),
      body: lists.isEmpty
          ? Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "No lists found. Press + button to add a new list"),
                        ],
                      ),
                    ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: StockListModelList(
                      stockLists: lists,
                      onStockListTap: (stockListModel) =>
                          _goTiListPageWithDataFromServer(stockListModel)),
                )
              ],
            ),
    );
  }
}
