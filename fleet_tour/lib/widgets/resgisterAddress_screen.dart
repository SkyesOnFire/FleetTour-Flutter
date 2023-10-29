import 'dart:convert';
import 'dart:math';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class registerAdressScreen extends StatefulWidget {
  const registerAdressScreen({super.key});

  @override
  State<registerAdressScreen> createState() => _registerAdressScreenState();
}

class _registerAdressScreenState extends State<registerAdressScreen> {
  final _formKey = GlobalKey<FormState>();
  Endereco endereco = Endereco();

  get http => null;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(ip, 'empresas');
      print(url);
      final body = json.encode(
        <String, dynamic>{
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

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      }
    }
  }

  void _consultarCep() async {
    final cep = _enteredCep;
    if (cep != null && cep.length == 8) {
      final url = Uri.https('viacep.com.br', 'ws/$cep/json');
      final response = await http.get(url);
      final body = json.decode(response.body);
      print(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _cepController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Qual o endereço da empresa?"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  8,
                  decoration: const InputDecoration(labelText: 'CEP'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe o CEP';
                    }
                    return null;
                  },
                  onTapOutside: (value) {
                    _consultarCep();
                    _registerAdressScreenState().setState(() {});
                  },
                ),
              ]),
            ),
          ),
        ));
  }
}
