import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterAddressScreen extends StatefulWidget {
  const RegisterAddressScreen({super.key});

  @override
  State<RegisterAddressScreen> createState() => _RegisterAddressScreenState();
}

class _RegisterAddressScreenState extends State<RegisterAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final Endereco _endereco = Endereco();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  void sendAddressToStorage(Endereco endereco) async {
    Get.toNamed('/registro/empresa', arguments: endereco);
  }

  void _consultarCep() async {
    if (_endereco.cep!.length == 8) {
      final cep = _endereco.cep!.trim();
      final url = Uri.https('viacep.com.br', '/ws/$cep/json');
      final response = await http.get(url);
      final body = json.decode(response.body);
      if (!body.containsKey('erro')) {
        _endereco.cidade = body['cidade'];
        _endereco.bairro = body['bairro'];
        _endereco.cidade = body['localidade'];
        _endereco.estado = body['uf'];
        _endereco.rua = body['logradouro'];
        _endereco.complemento = body['complemento'];
        _endereco.pais = 'Brasil';

        _bairroController.text = _endereco.bairro ?? '';
        _cidadeController.text = _endereco.cidade ?? '';
        _estadoController.text = _endereco.estado ?? '';
        _ruaController.text = _endereco.rua ?? '';
        _complementoController.text = _endereco.complemento ?? '';
        _paisController.text = _endereco.pais ?? '';
      } else {
        Get.closeAllSnackbars();
        Get.snackbar(
          'CEP não encontrado',
          'Por favor, informe um CEP válido',
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
          title: const Text("Qual o endereço da empresa?"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  maxLength: 10,
                  decoration: const InputDecoration(labelText: 'CEP'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!GetUtils.isLengthEqualTo(value, 10)) {
                      return 'Informe o CEP';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _endereco.cep = value;
                    if (GetUtils.isLengthEqualTo(_endereco.cep, 10)) {
                      _endereco.cep = _endereco.cep!.replaceAll('-', '');
                      _endereco.cep = _endereco.cep!.replaceAll('.', '');
                      if (!GetUtils.isNumericOnly(_endereco.cep!)) {
                        Get.closeAllSnackbars();
                        Get.snackbar(
                          'CEP não encontrado',
                          'Por favor, informe um CEP válido',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        _consultarCep();
                      }
                    }
                  },
                ),
                TextFormField(
                  maxLength: 10,
                  controller: _numeroController,
                  decoration: const InputDecoration(labelText: 'Número'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe o número';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.numero = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _ruaController,
                  decoration: const InputDecoration(labelText: 'Rua'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe a rua';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.rua = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _complementoController,
                  decoration: const InputDecoration(
                      labelText: 'Complemento (opcional)'),
                  onSaved: (value) {
                    _endereco.complemento = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe o bairro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.bairro = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe a cidade';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.cidade = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _estadoController,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe o estado';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.estado = value;
                  },
                ),
                TextFormField(
                  maxLength: 255,
                  controller: _paisController,
                  decoration: const InputDecoration(labelText: 'País'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, informe o país';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _endereco.pais = value;
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            sendAddressToStorage(_endereco);
                          }
                        },
                        child: const Text('Continuar Cadastro')),
                  ],
                )
              ]),
            ),
          ),
        ));
  }
}
