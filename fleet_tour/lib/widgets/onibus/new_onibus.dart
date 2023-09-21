import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

class NewOnibus extends StatefulWidget {
  const NewOnibus({super.key});

  @override
  State<NewOnibus> createState() {
    return _NewOnibusState();
  }
}

class _NewOnibusState extends State<NewOnibus> {
  final _formKey = GlobalKey<FormState>();
  var _enteredPlaca = '';
  var _enteredRenavam = '';
  var _enteredAno = '';
  var _enteredKm = '';
  var _enteredNumeroFrota = '';
  var _enteredCapacidade = 0;
  var _enteredTaf = '';
  var _enteredRegistroEstadual = '';

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.http(ip, 'veiculos');
      print(url);
      final body = json.encode(
        {
          'placa': _enteredPlaca,
          'renavam': _enteredRenavam,
          'ano': _enteredAno,
          'quilometragem': _enteredKm,
          'codFrota': _enteredNumeroFrota,
          'capacidade': _enteredCapacidade,
          'taf': _enteredTaf,
          'regEstadual': _enteredRegistroEstadual,
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
      //     // GroceryItem(
      //     //   id: DateTime.now().toString(),
      //     //   name: _enteredName,
      //     //   quantity: _enteredQuantity,
      //     //   category: _selectedCategory)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar novo veículo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 8,
                  decoration: const InputDecoration(
                    label: Text("Placa"),
                  ),
                  validator: (value) {
                    if (!RegExp(r"^[A-Z]{3}\-\d{4}$|^[A-Z]{3}\-\d{1}[A-Z]{1}\d{2}$").hasMatch(value!)) {
                      return 'Formato de placa inválido.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlaca = value!;
                  },
                ),
                TextFormField(
                  maxLength: 11,
                  decoration: const InputDecoration(
                    label: Text("Renavam"),
                  ),
                  validator: (value) {
                    if (!RegExp(r"^\d{11}$").hasMatch(value!)) {
                      return 'Renavam inválido. Deve ter 11 dígitos';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredRenavam = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Ano"),
                        ),
                        validator: (value) {
                          int? year = int.tryParse(value!);
                          if (year == null ||
                              year < 1900 ||
                              year > DateTime.now().year) {
                            return 'Ano inválido.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredAno = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 15,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quilometragem"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^\d+$").hasMatch(value!)) {
                            return 'Quilometragem inválida. Deve ser um número positivo';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredKm = value!;
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
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Codigo de Frota"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^\d{4}$").hasMatch(value!)) {
                            return 'Código de Frota inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredNumeroFrota = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Capacidade"),
                        ),
                        validator: (value) {
                          int? capacity = int.tryParse(value!);
                          if (capacity == null || capacity <= 0) {
                            return 'Capacidade inválida. Deve ser um número positivo';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredCapacidade = int.parse(value!);
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
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("TAF"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^\d{4}$").hasMatch(value!)) {
                            return 'TAF inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredTaf = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Registro Estadual"),
                        ),
                        validator: (value) {
                          if (!RegExp(r"^\d{4}$").hasMatch(value!)) {
                            return 'Registro Estadual inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredRegistroEstadual = value!;
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
                          child: const Text('Limpar')),
                      ElevatedButton(
                          onPressed: _saveItem, child: const Text('Cadastrar'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
