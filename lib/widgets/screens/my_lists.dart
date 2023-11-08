import 'package:aksje_app/models/stock_list_model.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDataFromServer();
  }

  void _fetchDataFromServer() async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context);
      var uid = userProvider.user!.uid;
      print(uid);
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/list/listsbyuid/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          lists = responseData
              .map((data) => StockListModel.fromJson(data))
              .toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.list),
            title: Text(lists[index].name),
            onTap: () {
              // Handle list tap
            },
          );
        },
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
