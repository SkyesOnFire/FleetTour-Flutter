import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Empresa empresa = Get.arguments;
  final Usuario _usuario = Usuario();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void doRegisterUser(Usuario usuario) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 15),
      );

      usuario.empresa = empresa;

      final url = Uri.http(ip, '/usuarios/registrar');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(usuario.toJson()),
      );
      print(jsonEncode(usuario.toJson()));
      print(response.statusCode);
      if (response.statusCode == 201) {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Usuário cadastrado com sucesso',
          'Você será redirecionado para a tela de login',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(3);
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Erro ao cadastrar usuário',
          'Por favor, tente novamente mais tarde',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro do Administrador'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  items: [
                    empresa.email.toString(),
                    empresa.emailResponsavel.toString()
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _usuario.login = value as String?;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Email para Login'),
                  validator: (value) {
                    if (value == null) {
                      return 'Escolha um email para utilizar como login';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty && GetUtils.isLengthLessThan(value, 8)) {
                      return 'Escolha uma senha, deve ser maior que 8 dígitos';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _usuario.senha = value;
                  },
                ),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty && !value.contains(" ")) {
                      return 'Entre com seu nome completo';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _usuario.nome = value;
                  },
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!GetUtils.isLengthEqualTo(value, 14)) {
                      return 'Entre com um CPF válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (GetUtils.isLengthEqualTo(value, 14)) {
                      _usuario.cpf = value;
                      _usuario.cpf = _usuario.cpf!.replaceAll('.', '');
                      _usuario.cpf = _usuario.cpf!.replaceAll('-', '');
                    }
                  },
                ),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Entre com seu número de telefone';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _usuario.telefone = value;
                    if (GetUtils.isLengthGreaterOrEqual(
                        _usuario.telefone, 14)) {
                      _usuario.telefone =
                          _usuario.telefone!.replaceAll('(', '');
                      _usuario.telefone =
                          _usuario.telefone!.replaceAll(')', '');
                      _usuario.telefone =
                          _usuario.telefone!.replaceAll('-', '');
                      GetUtils.removeAllWhitespace(_usuario.telefone!);
                    }
                  },
                ),
                DropdownButtonFormField(
                  items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _usuario.genero = value;
                  },
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (value) {
                    if (value == null) {
                      return 'Escolha um gênero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 10,
                  decoration:
                      const InputDecoration(labelText: 'Data de Nascimento'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!GetUtils.isLengthEqualTo(value, 10)) {
                      return 'Informe a data de nascimento';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (GetUtils.isLengthEqualTo(value, 10)) {
                      value = value.replaceAll('/', '-');
                      var splitValue = value.split('-');
                      value =
                          '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                      _usuario.dataNascimento = DateTime.parse(value);
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _usuario.ativo = true;
                      _usuario.nivelAcesso = 'ADMIN;';
                      _usuario.empresa = empresa;
                      doRegisterUser(_usuario);
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
