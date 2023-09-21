import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';

class NewEmpresa extends StatefulWidget {
  const NewEmpresa({Key? key}) : super(key: key);

  @override
  State<NewEmpresa> createState() => _NewEmpresaState();
}

class _NewEmpresaState extends State<NewEmpresa> {
  final _formKey = GlobalKey<FormState>();
  var _enteredCnpj = '';
  var _enteredNomeFantasia = '';
  var _enteredRazaoSocial = '';
  var _enteredEmail = '';
  var _enteredNomeResponsavel = '';
  var _enteredFoneResponsavel = '';
  var _enteredEmailResponsavel = '';
  List<int>? _enteredLogo;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newEmpresa = Empresa(
        id: 0, // Will be replaced by database ID
        cnpj: _enteredCnpj,
        nomeFantasia: _enteredNomeFantasia,
        razaoSocial: _enteredRazaoSocial,
        email: _enteredEmail,
        nomeResponsavel: _enteredNomeResponsavel,
        foneResponsavel: _enteredFoneResponsavel,
        emailResponsavel: _enteredEmailResponsavel,
        logo: _enteredLogo ?? [],
      );

      final url = Uri.http(ip, 'empresas');
      final body = json.encode(newEmpresa.toMap());
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.body);
      print(response.statusCode);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar nova empresa"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'CNPJ'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um CNPJ';
                    }
                    if (!RegExp(r"^\d{14}$").hasMatch(value)) {
                      return 'CNPJ inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredCnpj = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome Fantasia'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um Nome Fantasia';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredNomeFantasia = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Razão Social'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma Razão Social';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredRazaoSocial = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um e-mail';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome Responsável'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira o nome do responsável';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredNomeResponsavel = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Telefone Responsável'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um telefone';
                    }
                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredFoneResponsavel = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Email Responsável'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um e-mail';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmailResponsavel = value!;
                  },
                ),
                // Logo input (you'll need to implement this part according to how you're planning to handle logo uploads)
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
