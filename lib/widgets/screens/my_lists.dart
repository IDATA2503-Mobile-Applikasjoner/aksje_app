import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_list_components/stock_list_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/add_list.dart';
import 'package:aksje_app/models/user.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

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

  Future<void> _fetchDataFromServer() async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/listsbyuid/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          lists = responseData.map((data) => StockListModel.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        isLoading = false;
      }
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

@override
Widget build(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  User? user = userProvider.user;
  if (userProvider.user == null) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Login to see lists"),
            ],
          ),
        ),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Lists'),
    ),
    body: lists.isEmpty
        ? Center(
            child: isLoading
                ? CircularProgressIndicator()
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No lists found. Press + button to add a new list"),
                      ],
                    ),
                  ),
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: StockListModelList(
                  stockLists: lists,
                ),
              )
            ],
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddListPage()),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
}
}