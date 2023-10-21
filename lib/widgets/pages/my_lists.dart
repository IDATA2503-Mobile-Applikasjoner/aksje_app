import 'package:flutter/material.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyListsPageState();
  }
}

class _MyListsPageState extends State<MyListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('List 1'),
            onTap: () {
              // Handle list tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('List 2'),
            onTap: () {
              // Handle list tap
            },
          ),
          // Add more list tiles as needed
        ],
      ),
    );
  }
}
