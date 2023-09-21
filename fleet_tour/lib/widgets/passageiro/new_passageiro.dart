import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

class NewPassageiro extends StatefulWidget {
  const NewPassageiro({super.key});

  @override
  State<NewPassageiro> createState() {
    return _NewPassageiroState();
  }
}

class _NewPassageiroState extends State<NewPassageiro> {
  final _formKey = GlobalKey<FormState>();
  var _enteredNome = '';
  var _enteredRg = '';
  var _enteredOrgaoEmissor = '';
  var _enteredTipoCliente = '';
  DateTime _enteredDataNasc = DateTime(2003, 1, 1);

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(now.year - 20),
        firstDate: DateTime(1950),
        lastDate: DateTime(now.year));
    setState(() {
      _enteredDataNasc = pickedDate!;
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.http(ip, 'passageiros');
      print(url);
      final body = json.encode(
        {
          'nome': _enteredNome,
          'rg': _enteredRg,
          'orgaoEmissor': _enteredOrgaoEmissor,
          'tipoCliente': _enteredTipoCliente,
          'dataNasc': _enteredDataNasc.toIso8601String(),
          'id_Empresa': 1
        },
      );
      print(body);
      final response = await http.post(
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
        title: const Text("Cadastrar novo passageiro"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Nome"),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 11,
                        decoration: const InputDecoration(
                          label: Text("Orgão Emissor"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value!)) {
                            return 'Deve conter apenas letras';
                          }
                          if (value.trim().length < 2 ||
                              value.trim().length > 11) {
                            return 'Deve ter entre 2 e 11 caracteres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredOrgaoEmissor = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Rg"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^\d+$").hasMatch(value!)) {
                            return 'Deve conter apenas números';
                          }
                          if (value.trim().length < 2 ||
                              value.trim().length > 11) {
                            return 'Deve ter entre 2 e 11 caracteres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredRg = value!;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 10,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Data de Nascimento:     '),
                    Text(
                      _enteredDataNasc == null
                          ? 'Nenhuma data selecionada'
                          : _enteredDataNasc.year.toString() +
                              '/' +
                              _enteredDataNasc.month.toString() +
                              '/' +
                              _enteredDataNasc.day.toString(),
                    ),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month)),
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
                          child: const Text('Limpar')),
                      ElevatedButton(
                          onPressed: _saveItem, child: const Text('Cadastrar')),
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
