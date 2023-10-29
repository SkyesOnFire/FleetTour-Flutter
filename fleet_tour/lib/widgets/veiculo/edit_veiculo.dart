import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

import 'package:fleet_tour/models/veiculo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditVeiculo extends StatefulWidget {
  const EditVeiculo({super.key, required this.veiculo});

  final Veiculo veiculo;

  @override
  State<EditVeiculo> createState() {
    // ignore: no_logic_in_create_state
    return _EditVeiculoState(veiculo: veiculo);
  }
}

class _EditVeiculoState extends State<EditVeiculo> {
  final Veiculo veiculo;
  _EditVeiculoState({required this.veiculo});
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
    _enteredPlaca = veiculo.placa.toString();
    _enteredRenavam = veiculo.renavam.toString();
    _enteredAno = veiculo.ano.toString();
    _enteredKm = veiculo.km.toString();
    _enteredNumeroFrota = veiculo.numeroFrota.toString();
    _enteredCapacidade = veiculo.capacidade;
    _enteredTaf = veiculo.taf.toString();
    _enteredRegistroEstadual = veiculo.regEstadual.toString();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(ip, 'veiculos/${veiculo.id}');
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final response = await http.put(
        url,
        headers: {
          "authorization": "Bearer ${token!}",
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (!context.mounted) {
        return;
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Ônibus editado.'),
        ));
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Text('Erro ao editar ônibus.'),
        ));
      }
      Navigator.of(context).pop();
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
                  initialValue: veiculo.placa.toString(),
                  8,
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
                  initialValue: veiculo.renavam.toString(),
                  11,
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
                        initialValue: veiculo.ano.toString(),
                        4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Ano"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ser um ano válido';
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
                        initialValue: veiculo.km.toString(),
                        15,
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
                        initialValue: veiculo.numeroFrota.toString(),
                        4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Código de Frota"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 números.';
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
                        initialValue: veiculo.capacidade.toString(),
                        2,
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
                        initialValue: veiculo.taf.toString(),
                        4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("TAF"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 números.';
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
                        initialValue: veiculo.regEstadual.toString(),
                        4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Registro Estadual"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 4) {
                            return 'Deve ter 4 números.';
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
