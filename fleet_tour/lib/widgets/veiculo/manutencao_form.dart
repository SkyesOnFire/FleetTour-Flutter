import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/manutencao.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ManutencaoForm extends StatefulWidget {
  const ManutencaoForm({super.key});

  @override
  State<ManutencaoForm> createState() => _ManutencaoFormState();
}

class _ManutencaoFormState extends State<ManutencaoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Manutencao _manutencao = Manutencao();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 500),
      );
      var storage = GetStorage();
      final veiculoId = storage.read("veiculoId");
      final url = Uri.http(ip, 'manutencoes/$veiculoId');
      final token = storage.read("token");
      final body = jsonEncode(_manutencao.toJson());
      final response = await http.post(
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

      if (response.statusCode == 201) {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Manutenção cadastrada com sucesso',
          'Você será redirecionado para a tela de veículos',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Erro ao cadastrar manutenção',
          'Por favor, tente novamente mais tarde',
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
        title: const Text("Cadastrar nova manutenção"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(label: Text("Quilometragem")),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      KmInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (value) {
                      value = value!.replaceAll('.', '');
                      _manutencao.km = double.tryParse(value ?? '') ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a quilometragem';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(label: Text("Valor")),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      RealInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (value) {
                      value = value!.replaceAll('.', '');
                      _manutencao.valor = double.tryParse(value ?? '') ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(label: Text("Nome da Oficina")),
                    onSaved: (value) {
                      _manutencao.nomeOficina = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(label: Text("Observações")),
                    onSaved: (value) {
                      _manutencao.observacao = value;
                    },
                    maxLines: 3,
                  ),
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
                          onPressed: _saveForm, child: const Text('Cadastrar'))
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
