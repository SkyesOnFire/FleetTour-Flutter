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

class NewPassageiroCompras extends StatefulWidget {
  const NewPassageiroCompras({super.key});

  @override
  State<NewPassageiroCompras> createState() {
    return _NewPassageiroComprasState();
  }
}

class _NewPassageiroComprasState extends State<NewPassageiroCompras> {
  final storage = GetStorage();

  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _enderecoLojaController = TextEditingController();
  final MaskTextInputFormatter rgMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###-#', // This is the mask for the RG format.
    filter: {"#": RegExp(r'[0-9Xx]')}, // RG can end with a number or 'X'/'x'.
  );
  final _formKey = GlobalKey<FormState>();
  final Passageiro _passageiro = Passageiro();

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
      final url = Uri.http(ip, 'passageiros');
      final body = json.encode(_passageiro.toJson());
      final response = await http.post(url,
          headers: {
            'authorization': "Bearer ${token!}",
            'content-type': "application/json",
          },
          body: body);

      if (response.statusCode == 201) {
        Get.close(1);
        Get.snackbar(
          'Sucesso',
          'Passageiro cadastrado com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.snackbar(
          'Erro',
          'Erro ao cadastrar passageiro!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _passageiro.tipoCliente = 'Compras';
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            rgMaskFormatter,
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
                            if (value!.trim().length < 10) {
                              return 'Entre com uma data de nascimento válida';
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 18,
                          decoration: const InputDecoration(labelText: 'CNPJ'),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CnpjInputFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (!GetUtils.isLengthEqualTo(value, 18)) {
                              return 'Informe o CNPJ';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _passageiro.cnpj = value;
                            if (GetUtils.isLengthEqualTo(
                                _passageiro.cnpj, 18)) {
                              _passageiro.cnpj =
                                  _passageiro.cnpj!.replaceAll('-', '');
                              _passageiro.cnpj =
                                  _passageiro.cnpj!.replaceAll('.', '');
                              _passageiro.cnpj =
                                  _passageiro.cnpj!.replaceAll('/', '');
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 150,
                          decoration: const InputDecoration(
                            label: Text("Nome Fantasia"),
                          ),
                          validator: (value) {
                            if (value!.trim().length <= 2) {
                              return 'Entre com o nome fantasia do seu CNPJ';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passageiro.nomeFantasia = value!;
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
                            if (_passageiro.enderecoLoja != null) {
                              _enderecoController.text =
                                  "${_passageiro.endereco!.rua}, ${_passageiro.endereco!.numero} - ${_passageiro.endereco!.cidade} / ${_passageiro.endereco!.estado}";
                            }
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
                          controller: _enderecoLojaController,
                          decoration: const InputDecoration(
                            label: Text("Endereço Loja"),
                          ),
                          onTap: () async {
                            await Get.toNamed('/endereco',
                                arguments: _passageiro.enderecoLoja);
                            _passageiro.enderecoLoja =
                                storage.read('temp_endereco');
                            storage.remove('temp_endereco');
                            if (_passageiro.enderecoLoja != null) {
                              _enderecoLojaController.text =
                                  "${_passageiro.enderecoLoja!.rua}, ${_passageiro.enderecoLoja!.numero} - ${_passageiro.enderecoLoja!.cidade} / ${_passageiro.enderecoLoja!.estado}";
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
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Limpar')),
                      ElevatedButton(
                          onPressed: _savePassageiro,
                          child: const Text('Cadastrar')),
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
