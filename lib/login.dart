import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/navigation.dart';
import 'package:my_app/register.dart';
import 'package:my_app/role.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/login.webp"), height: 350),
            const SizedBox(height: 20),
            const Text(
              "Sign in",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _userController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
                hintText: 'Enter a valid email address',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_userController.text.isEmpty ||
                      _passController.text.isEmpty) {
                    throw Exception("email y contraseña requeridos");
                  }

                  print("Email: ${_userController.text}");
                  print("Password: ${_passController.text}");

                  ApiService auth = ApiService();
                  var response = await auth.login(
                    _userController.text,
                    _passController.text,
                  );

                  Role rol = Role.values.byName(response["user"]["role"]);
                  int id = response["user"]["id"];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Navigation(chosenRole: rol, id: id),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: const Text(
                    'Register here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
