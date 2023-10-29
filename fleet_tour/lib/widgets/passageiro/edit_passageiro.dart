import 'dart:convert';

import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/passageiro.dart'; // Updated import statement
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPassageiro extends StatefulWidget {
  const EditPassageiro({Key? key, required this.passageiro})
      : super(key: key); // Fixed parameter name

  final Passageiro passageiro; // Updated class name

  @override
  State<EditPassageiro> createState() =>
      // ignore: no_logic_in_create_state
      _EditPassageiroState(passageiro: passageiro); // Fixed class name
}

class _EditPassageiroState extends State<EditPassageiro> {
  final Passageiro passageiro; // Updated class name
  _EditPassageiroState({required this.passageiro}); // Updated class name
  final _formKey = GlobalKey<FormState>();
  late String _enteredNome; // Updated variable name
  late String _enteredRg; // Updated variable name
  late String _enteredOrgaoEmissor;
  late String _enteredTipoCliente; // Updated variable name
  // ignore: unused_field
  late DateTime _enteredDataNasc;

  @override
  void initState() {
    super.initState();
    _enteredNome = passageiro.nome; // Updated variable name
    _enteredRg = passageiro.rg; // Updated variable name
    _enteredOrgaoEmissor = passageiro.orgaoEmissor;
    _enteredTipoCliente = passageiro.tipoCliente; // Updated variable name
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url =
          Uri.http(ip, 'passageiros/${passageiro.id}'); // Updated endpoint
      final body = json.encode(
        {
          'nome': _enteredNome,
          'rg': _enteredRg,
          'orgaoEmissor': _enteredOrgaoEmissor,
          'tipoCliente': _enteredTipoCliente,
          'dataNasc': _enteredDataNasc,
        },
      );
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
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
        title: const Text("Editar passageiro"), // Updated title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  255,
                  initialValue: _enteredNome,
                  decoration: const InputDecoration(
                    labelText: "Nome", // Updated label text
                  ),
                  validator: (value) {
                    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value!)) {
                      return 'O nome deve conter apenas letras e espaços';
                    }
                    if (value.trim().length <= 1 || value.trim().length > 50) {
                      return 'O nome deve ter entre 2 e 50 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredNome = value!;
                  },
                ),
                TextFormField(
                  11,
                  initialValue: _enteredRg,
                  decoration: const InputDecoration(
                    labelText: "Rg", // Updated label text
                  ),
                  validator: (value) {
                    if (!RegExp(r"^\d+$").hasMatch(value!)) {
                      return 'Deve conter apenas números';
                    }
                    if (value.trim().length < 2 || value.trim().length > 11) {
                      return 'Deve ter entre 2 e 11 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredRg = value!;
                  },
                ),
                TextFormField(
                  11,
                  initialValue: _enteredOrgaoEmissor,
                  decoration: const InputDecoration(
                    labelText: "Orgão Emissor", // Updated label text
                  ),
                  validator: (value) {
                    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value!)) {
                      return 'Deve conter apenas letras';
                    }
                    if (value.trim().length < 2 || value.trim().length > 11) {
                      return 'Deve ter entre 2 e 11 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredOrgaoEmissor = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _enteredTipoCliente,
                        10,
                        decoration: const InputDecoration(
                          label: Text("Tipo de cliente"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value!)) {
                            return 'Deve conter apenas letras';
                          }
                          if (value.trim().length < 2 ||
                              value.trim().length > 10) {
                            return 'Deve ter entre 2 e 10 caracteres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredTipoCliente = value!;
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Limpar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
