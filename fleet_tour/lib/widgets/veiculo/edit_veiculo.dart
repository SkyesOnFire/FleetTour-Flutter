import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/data/validationUtils.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

class EditVeiculo extends StatefulWidget {
  const EditVeiculo({super.key});

  @override
  State<EditVeiculo> createState() => _EditVeiculoState();
}

class _EditVeiculoState extends State<EditVeiculo> {
  final _formKey = GlobalKey<FormState>();
  final Veiculo _veiculo = Get.arguments;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 2),
      );
      var storage = GetStorage();
      final token = storage.read("token");
      final url = Uri.http(ip, 'veiculos/${_veiculo.idVeiculo}');
      final body = json.encode(_veiculo.toJson());
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
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Sucesso',
          'Ônibus editado com sucesso.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Erro',
          'Erro ao editar ônibus.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar dados do ônibus"),
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
                  initialValue: _veiculo.placa,
                  decoration: const InputDecoration(
                    label: Text("Placa"),
                  ),
                  inputFormatters: [
                    PlacaVeiculoInputFormatter(),
                  ],
                  validator: (value) {
                    value = value!.toUpperCase();
                    if (!RegExp(
                            r"^[A-Z]{3}\-\d{4}$|^[A-Z]{3}\-\d{1}[A-Z]{1}\d{2}$")
                        .hasMatch(value)) {
                      return 'Formato de placa inválido.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    value = value!.toUpperCase();
                    _veiculo.placa = value;
                  },
                ),
                TextFormField(
                  maxLength: 11,
                  initialValue: _veiculo.renavam,
                  decoration: const InputDecoration(
                    label: Text("Renavam"),
                  ),
                  validator: (value) {
                    if (!validarRenavam(value!)) {
                      return 'Renavam inválido.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _veiculo.renavam = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 4,
                        initialValue: _veiculo.ano,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Ano"),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                          _veiculo.ano = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 11,
                        initialValue: _veiculo.quilometragem,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Quilometragem"),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CustomKmInputFormatter(),
                        ],
                        validator: (value) {
                          if (GetUtils.isLengthLessOrEqual(value, 0)) {
                            return 'Quilometragem inválida.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _veiculo.quilometragem = value!;
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
                        initialValue: _veiculo.codFrota,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Código de Frota"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isNumericOnly(value!) &&
                              !GetUtils.isLengthEqualTo(value, 4)) {
                            return 'Código de Frota inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _veiculo.codFrota = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        initialValue: _veiculo.capacidade.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Capacidade"),
                        ),
                        validator: (value) {
                          int? capacity = int.tryParse(value!);
                          if (capacity == null || capacity <= 0) {
                            return 'Capacidade inválida.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _veiculo.capacidade = int.parse(value!);
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
                        initialValue: _veiculo.taf,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("TAF (Número ANTT)"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isNumericOnly(value!) &&
                              !GetUtils.isLengthEqualTo(value, 4)) {
                            return 'TAF inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _veiculo.taf = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 4,
                        initialValue: _veiculo.regEstadual,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Registro Estadual (DER)"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isNumericOnly(value!) &&
                              !GetUtils.isLengthEqualTo(value, 4)) {
                            return 'Registro Estadual inválido. Deve ter 4 dígitos';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _veiculo.regEstadual = value!;
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
                        initialValue:
                            formatDateForInput(_veiculo.ultimaVistoria),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          label: Text("Data da última vistoria"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isLengthEqualTo(value, 10)) {
                            return 'Data inválida.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (GetUtils.isLengthEqualTo(value, 10)) {
                            value = value.replaceAll('/', '-');
                            var splitValue = value.split('-');
                            value =
                                '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                            _veiculo.ultimaVistoria = DateTime.parse(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 10,
                        initialValue: formatDateForInput(_veiculo.seguro),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          label: Text("Data de emissão do seguro"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isLengthEqualTo(value, 10)) {
                            return 'Data inválida.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (GetUtils.isLengthEqualTo(value, 10)) {
                            value = value.replaceAll('/', '-');
                            var splitValue = value.split('-');
                            value =
                                '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                            _veiculo.seguro = DateTime.parse(value);
                          }
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
                        initialValue:
                            formatDateForInput(_veiculo.licenciamentoAntt),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          label: Text("Data do licenciamento ANTT"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isLengthEqualTo(value, 10)) {
                            return 'Data inválida.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (GetUtils.isLengthEqualTo(value, 10)) {
                            value = value.replaceAll('/', '-');
                            var splitValue = value.split('-');
                            value =
                                '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                            _veiculo.licenciamentoAntt = DateTime.parse(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        maxLength: 10,
                        initialValue:
                            formatDateForInput(_veiculo.licenciamentoDer),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter(),
                        ],
                        decoration: const InputDecoration(
                          label: Text("Data do licenciamento DER"),
                        ),
                        validator: (value) {
                          if (!GetUtils.isLengthEqualTo(value, 10)) {
                            return 'Data inválida.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (GetUtils.isLengthEqualTo(value, 10)) {
                            value = value.replaceAll('/', '-');
                            var splitValue = value.split('-');
                            value =
                                '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                            _veiculo.licenciamentoDer = DateTime.parse(value);
                          }
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
                          onPressed: _saveItem, child: const Text('Salvar'))
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
