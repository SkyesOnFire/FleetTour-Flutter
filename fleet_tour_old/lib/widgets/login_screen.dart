import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/widgets/onibus/expenses.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredLogin = '';
  var _enteredPassword = '';
  var imageLogo = const AssetImage('fleet_tour/assets/images/cut_logo.png');

  void _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, String> uParams = {
        'login': _enteredLogin,
        'senha': _enteredPassword,
      };

      final url = Uri.http(ip, 'usuarios/login', uParams);
      final response = await http.get(url);

      if (!context.mounted) {
        return;
      }

      if (response.body == "true") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Expenses(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Usuário ou senha incorreta.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  maxLength: 25,
                  decoration: const InputDecoration(
                    label: Text("Login"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entre com um login valido.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredLogin = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text("Senha"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Favor entrar com uma senha valida';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _attemptLogin, child: const Text('Entrar'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
