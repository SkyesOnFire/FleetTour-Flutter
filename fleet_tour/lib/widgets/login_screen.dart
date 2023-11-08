import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/widgets/veiculo/veiculo.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

      //spinner widget
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 2),
      );

      Map<String, String> uBody = {
        'login': _enteredLogin,
        'senha': _enteredPassword,
      };

      final url = Uri.http(ip, 'rest/auth/login');
      final response = await http.post(url,
          body: jsonEncode({"login": _enteredLogin, "senha": _enteredPassword}),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          });

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final storage = GetStorage();

        if (!context.mounted) {
          return;
        }

        storage.writeInMemory("token", jsonDecode(response.body)['token']);

        Get.close(1);

        Get.to(() => const Veiculos());
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          "Erro",
          "Senha ou usuário incorreto.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _doLogin() {
    Get.toNamed("/veiculos");
  }

  void _doRegister() {
    Get.toNamed("/registro/endereco");
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
                  maxLength: 255,
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
                        maxLength: 255,
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
