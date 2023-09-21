import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

import 'package:fleet_tour/models/onibus.dart';

class EditOnibus extends StatefulWidget {
  const EditOnibus({super.key, required this.onibus});

  final Onibus onibus;

  @override
  State<EditOnibus> createState() {
    // ignore: no_logic_in_create_state
    return _EditOnibusState(onibus: onibus);
  }
}

class _EditOnibusState extends State<EditOnibus> {
  final Onibus onibus;
  _EditOnibusState({required this.onibus});
  final _formKey = GlobalKey<FormState>();
  late String _enteredPlaca;
  late String _enteredRenavam;
  late String _enteredAno;
  late String _enteredKm;
  late String _enteredNumeroFrota;
  late int _enteredCapacidade;
  late String _enteredTaf;
  late String _enteredRegistroEstadual;

  @override
  void initState() {
    super.initState();
    _enteredPlaca = onibus.placa.toString();
    _enteredRenavam = onibus.renavam.toString();
    _enteredAno = onibus.ano.toString();
    _enteredKm = onibus.km.toString();
    _enteredNumeroFrota = onibus.numeroFrota.toString();
    _enteredCapacidade = onibus.capacidade;
    _enteredTaf = onibus.taf.toString();
    _enteredRegistroEstadual = onibus.regEstadual.toString();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.http(ip, 'veiculos/${onibus.id}');
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
        title: const Text("Editar veículo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: onibus.placa.toString(),
                  maxLength: 8,
                  decoration: const InputDecoration(
                    label: Text("Placa"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 8) {
                      return 'Deve ser uma placa valida';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlaca = value!;
                  },
                ),
                TextFormField(
                  initialValue: onibus.renavam.toString(),
                  maxLength: 11,
                  decoration: const InputDecoration(
                    label: Text("Renavam"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 11) {
                      return 'Deve ser um renavam valido';
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
                        initialValue: onibus.ano.toString(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Ano"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ser um ano valido';
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
                        initialValue: onibus.km.toString(),
                        maxLength: 15,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quilometragem"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1) {
                            return 'Deve ser uma quilometragem real.';
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
                        initialValue: onibus.numeroFrota.toString(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Codigo de Frota"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 numeros.';
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
                        initialValue: onibus.capacidade.toString(),
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Capacidade"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Deve ser um valor positivo.';
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
                        initialValue: onibus.taf.toString(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("TAF"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 numeros.';
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
                        initialValue: onibus.regEstadual.toString(),
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Registro Estadual"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 numeros.';
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
