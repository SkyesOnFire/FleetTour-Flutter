import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

import 'package:fleet_tour/models/passageiro.dart'; // Updated import statement

class EditPassageiro extends StatefulWidget {
  const EditPassageiro({Key? key, required this.passageiro})
      : super(key: key); // Fixed parameter name

  final Passageiro passageiro; // Updated class name

  @override
  State<EditPassageiro> createState() =>
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
  late DateTime _enteredDataNasc;

  @override
  void initState() {
    super.initState();
    _enteredNome = passageiro.nome; // Updated variable name
    _enteredRg = passageiro.rg; // Updated variable name
    _enteredOrgaoEmissor = passageiro.orgaoEmissor;
    _enteredTipoCliente = passageiro.tipoCliente; // Updated variable name
    _enteredDataNasc = passageiro.dataNasc;
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
                  initialValue: _enteredNome,
                  decoration: const InputDecoration(
                    labelText: "Nome", // Updated label text
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do passageiro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredNome = value!;
                  },
                ),
                TextFormField(
                  initialValue: _enteredRg,
                  decoration: const InputDecoration(
                    labelText: "Rg", // Updated label text
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o rg do passageiro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredRg = value!;
                  },
                ),
                TextFormField(
                  initialValue: _enteredOrgaoEmissor,
                  decoration: const InputDecoration(
                    labelText: "Orgão Emissor", // Updated label text
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o orgão emissor do passageiro';
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
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Tipo de cliente"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 10) {
                            return 'Deve ter 4 letras.';
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Text('Data de Nascimento:     '),
                //     Text(_enteredDataNasc == null
                //         ? 'Nenhuma data selecionada'
                //         : _enteredDataNasc.year.toString() +
                //             '/' +
                //             _enteredDataNasc.month.toString() +
                //             '/' +
                //             _enteredDataNasc.day.toString()),
                //     IconButton(
                //         onPressed: _presentDatePicker,
                //         icon: const Icon(Icons.calendar_month))
                //   ],
                // ),
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
