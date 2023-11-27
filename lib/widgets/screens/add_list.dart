import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/widgets/components/flush_bar.dart';
import '../../globals.dart' as globals;

/// Page for adding a new list.
class AddListPage extends StatefulWidget {
  const AddListPage({Key? key}) : super(key: key);

  @override
  _AddListPageState createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  final TextEditingController nameController = TextEditingController();

  /// Adds a list to the server and returns a boolean indicating success.
  ///
  /// [context] is the BuildContext and [name] is the name of the new list.
  Future<bool> _addListToServer(BuildContext context, String name) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse('${globals.baseUrl}/api/list');
      var body = jsonEncode({
        "name": name,
        "user": {"uid": uid}
      });
      var response = await http.post(
        baseURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      return response.statusCode == 201;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Creates a new list.
  ///
  /// Invokes [_addListToServer] and shows an appropriate message based on the result.
  void _createList(BuildContext context, String name) async {
    try {
      bool added = await _addListToServer(context, name);
      if (added) {
        buildFlushBar(context, "List was created", "Info", const Color.fromARGB(255, 38, 104, 35), const Color.fromARGB(255, 45, 143, 0));
      } else {
        buildFlushBar(context, "Could not create list", "Error", const Color.fromARGB(255, 175, 25, 25), const Color.fromARGB(255, 233, 0, 0));
      }
    } catch (e) {
      buildFlushBar(context, "Error: ${e.toString()}", "Error",const Color.fromARGB(255, 175, 25, 25), const Color.fromARGB(255, 233, 0, 0));
    }
  }

  /// Checks if the list name is valid.
  ///
  /// Returns false if name is 'Favorites' or 'favorites', otherwise true.
  bool _checkIfNameIsValid(String name) {
    return !(name == "Favorites" || name == "favorites");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add List"),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainPage(selectedIndex: 1)),
          ),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "New List Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                if (!_checkIfNameIsValid(name)) {
                  buildFlushBar(context, "List with name $name already exists", "Error", const Color.fromARGB(255, 175, 25, 25), const Color.fromARGB(255, 233, 0, 0));
                } else {
                  _createList(context, name);
                }
              },
              child: const Text('Create List'),
            ),
          ],
        ),
      ),
    );
  }
}
