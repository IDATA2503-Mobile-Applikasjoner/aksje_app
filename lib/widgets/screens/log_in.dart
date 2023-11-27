import 'package:aksje_app/models/user.dart';
import 'package:aksje_app/providers/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/sign-up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:aksje_app/widgets/components/login_button.dart';
import 'package:aksje_app/widgets/components/flush_bar.dart';
import '../../globals.dart' as globals;

//Represent the login page.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool isLoggedIn = false;
  bool isLoading = false;

  //Sends authetication request to the server
  Future<void> login(
      String email, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('${globals.baseUrl}/api/user/authenticate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['jwt'];
      storeToken(token);
      setState(() {
        isLoggedIn = true;
        getLoginUser();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      buildFlushBar(context, 'Email or password is wrong', "Error", const Color.fromARGB(255, 175, 25, 25),const Color.fromARGB(255, 233, 0, 0));
    }
  }

  //Gets the authenticated user from the server.
  Future<void> getLoginUser() async {
    String? token = await getToken();
    if (token != null) {
      var url = Uri.parse('${globals.baseUrl}/api/user/sessionuser');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var user = User.fromJson(jsonResponse);

        Provider.of<UserProvider>(context, listen: false).setUser(user);
        navMainPage(context);

        print('User: ${user.toJson()}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else {
      print('Token not found');
    }
  }

  //Store the JWT toke in the TokeManager
  void storeToken(String token) async {
    TokenManager.storeToken(token);
  }

  //Gets the JWT toke from TokeManager
  Future<String?> getToken() async {
    String? token = await TokenManager.getToken();
    return token;
  }

  //Removes JWT token from Toke Manager
  void removeToken() async {
    TokenManager.removeToken();
  }

  //Navigates to sign up page.
  void navSignUpPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => (const SignUp())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            buildLoginButton(
                isLoading, emailController, passwordController, login, context),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 100, 100, 100),
              ),
              onPressed: () {
                navSignUpPage();
              },
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
