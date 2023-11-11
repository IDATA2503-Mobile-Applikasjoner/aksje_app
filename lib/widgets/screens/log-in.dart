import 'package:aksje_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/sign-up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:aksje_app/widgets/components/login_button.dart';
import 'package:another_flushbar/flushbar.dart';

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


void login(String email, String password, BuildContext context) async {

    setState(() {
    isLoading = true;
  });

  var url = Uri.parse('http://10.0.2.2:8080/api/user/authenticate');
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

  if(response.statusCode == 200) {
    String token = jsonDecode(response.body)['jwt'];
      storeToken(token);
      setState(() {
        isLoggedIn = true;
        getLoginUser();
        isLoading = false;
      }
    );
  } else {
    setState(() {
      isLoading = false;
    });
    showFloatingFlushbar(context);
  }
}

void getLoginUser() async {
  String? token = await getToken();
  if (token != null) {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/sessionuser');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include the token in the header
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var user = User.fromJson(jsonResponse); // Assuming User class with fromJson method

      Provider.of<UserProvider>(context, listen: false).setUser(user);
      navInventory(context);

      print('User: ${user.toJson()}'); // Assuming toJson method is defined in User class
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } else {
    print('Token not found');
  }
}

// Storing the token securely
  void storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  // Fetching the stored token
  Future<String?> getToken() async {
    String? token = await storage.read(key: 'jwt_token');
    return token;
  }

  // Removing the token when the user logs out
  void removeToken() async {
    await storage.delete(key: 'jwt_token');
  }

    void navSignUpPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => (SignUp())),
    );
  }

  void showFloatingFlushbar(BuildContext context) {
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
      title: 'Error',
      message: 'Email or password is wrong',
      margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
      flushbarPosition: FlushbarPosition.TOP, 
      duration: const Duration(seconds: 3),
    ).show(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestBro'),
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
            buildLoginButton(isLoading, emailController, passwordController, login, context),
            ElevatedButton(
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
