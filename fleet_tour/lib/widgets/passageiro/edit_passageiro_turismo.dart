import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/data/validation_utils.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditPassageiroTurismo extends StatefulWidget {
  const EditPassageiroTurismo({super.key});

  @override
  State<EditPassageiroTurismo> createState() {
    return _EditPassageiroTurismoState();
  }
}

class _EditPassageiroTurismoState extends State<EditPassageiroTurismo> {
  final _formKey = GlobalKey<FormState>();
  final Passageiro _passageiro = Get.arguments;
  final storage = GetStorage();
  final TextEditingController _enderecoController = TextEditingController();
  final MaskTextInputFormatter rgMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###-#', // This is the mask for the RG format.
    filter: {"#": RegExp(r'[0-9Xx]')}, // RG can end with a number or 'X'/'x'.
  );

  void _savePassageiro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 500),
      );

      final token = storage.read("token");
      final url = Uri.http(ip, 'passageiros/${_passageiro.idPassageiro}');
      final body = json.encode(_passageiro.toJson());
      final response = await http.put(url,
          headers: {
            'authorization': "Bearer ${token!}",
            'content-type': "application/json",
          },
          body: body);

      if (response.statusCode == 201) {
        Get.close(1);
        Get.snackbar(
          'Sucesso',
          'Passageiro editado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.snackbar(
          'Erro',
          'Erro ao editar passageiro!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _passageiro.tipoCliente = 'Turismo';
    _enderecoController.text =
        "${_passageiro.endereco!.rua}, ${_passageiro.endereco!.numero} - ${_passageiro.endereco!.cidade} / ${_passageiro.endereco!.estado}";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar passageiro"),
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
                    initialValue: _passageiro.nome,
                    decoration: const InputDecoration(
                      label: Text("Nome Completo"),
                    ),
                    validator: (value) {
                      if (value!.trim().length <= 8) {
                        return 'O nome deve conter apenas letras e espaços';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _passageiro.nome = value!;
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _passageiro.rg,
                          maxLength: 12,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            rgMaskFormatter
                          ],
                          decoration: const InputDecoration(
                            label: Text("RG"),
                          ),
                          validator: (value) {
                            if (value!.trim().length <= 4) {
                              return 'Entre com um RG válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.rg = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 6,
                          initialValue: _passageiro.orgaoEmissor,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Orgão emissor"),
                          ),
                          validator: (value) {
                            if (value!.trim().length <= 2) {
                              return 'Entre com um orgão emissor válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.orgaoEmissor = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _passageiro.cpf,
                          maxLength: 14,
                          decoration: const InputDecoration(
                            label: Text("CPF"),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!GetUtils.isCpf(value!)) {
                              return 'Entre com um CPF válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.cpf = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue:
                              formatDateForInput(_passageiro.dataNasc!),
                          maxLength: 10,
                          decoration: const InputDecoration(
                            label: Text("Data de nascimento"),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DataInputFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!GetUtils.isLengthEqualTo(value, 10)) {
                              return 'Informe a data de nascimento';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (GetUtils.isLengthEqualTo(value, 10)) {
                              value = value!.replaceAll('/', '-');
                              var splitValue = value.split('-');
                              value =
                                  '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                              _passageiro.dataNasc = DateTime.parse(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _passageiro.telefone,
                          maxLength: 15,
                          decoration: const InputDecoration(
                            label: Text("Telefone"),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.trim().length > 15) {
                              return 'Entre com um telefone válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.telefone = value!;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _passageiro.email,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (!isValidEmail(value!)) {
                              return 'Entre com um email válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.email = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _enderecoController,
                          decoration: const InputDecoration(
                            label: Text("Endereço"),
                          ),
                          onTap: () async {
                            await Get.toNamed('/endereco',
                                arguments: _passageiro.endereco);
                            _passageiro.endereco =
                                storage.read('temp_endereco');
                            storage.remove('temp_endereco');
                            if (_passageiro.endereco != null) {
                              _enderecoController.text =
                                  "${_passageiro.endereco!.rua}, ${_passageiro.endereco!.numero} - ${_passageiro.endereco!.cidade} / ${_passageiro.endereco!.estado}";
                            }
                          },
                        ),
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
                            Get.close(1);
                          },
                          child: const Text('Cancelar')),
                      ElevatedButton(
                          onPressed: _savePassageiro,
                          child: const Text('Salvar')),
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
