import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/svg_icon.dart';
import 'package:fleet_tour/widgets/resgisterAddress_screen.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/widgets/veiculo/veiculo.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredLogin = '';
  var _enteredPassword = '';

  void _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var hash = "{bcrypt}";

      hash += await FlutterBcrypt.hashPw(
          password: _enteredPassword, salt: r'$2b$06$C6UzMDM.H6dfI/f/IKxGhu');

      Map<String, String> uBody = {
        'login': _enteredLogin,
        'senha': hash,
      };

      final url = Uri.https(ip, 'rest/auth/login');
      final response = await http.post(url,
          body: jsonEncode({"login": _enteredLogin, "senha": hash}),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          });

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        if (!context.mounted) {
          return;
        }

        prefs.setString("token", response.body);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Veiculos(),
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

  void _doRegister() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const registerAdressScreen(),
      ),
    );
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
                SvgPicture.string(
                  svgLogo,
                  height: 300,
                  width: 300,
                ),
                TextFormField(
                  255,
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
                        255,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: _attemptLogin, child: const Text('Entrar')),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: _doRegister, child: const Text("Cadastrar"))
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
