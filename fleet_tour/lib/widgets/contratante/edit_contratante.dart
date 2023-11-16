import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/data/validation_utils.dart';
import 'package:fleet_tour/models/contratante.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';

class EditContratante extends StatefulWidget {
  const EditContratante({super.key});

  @override
  State<EditContratante> createState() => _EditContratanteState();
}

class _EditContratanteState extends State<EditContratante> {
  final storage = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final Contratante _contratante = Get.arguments;
  final _enderecoController = TextEditingController();

  void _editContratante() async {
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
      final token = storage.read("token");
      final url = Uri.http(ip, 'contratantes/${_contratante.idContratante}');
      final body = json.encode(_contratante.toJson());
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
          'Contratante editado com sucesso.',
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
          'Erro ao editar contratante.',
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
    _enderecoController.text = "${_contratante.endereco!.rua}, ${_contratante.endereco!.numero} - ${_contratante.endereco!.cidade} / ${_contratante.endereco!.estado}";;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar contratante"),
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
                  child: DropdownButtonFormField(
                    value: _contratante.tipoPessoa,
                    items: ["Jurídica", "Física"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: null,
                    decoration: const InputDecoration(labelText: 'CPF ou CNPJ'),
                    validator: (value) {
                      if (value == null) {
                        return 'Escolha pessoa física ou jurídica';
                      }
                      return null;
                    },
                  ),
                ),
                if (_contratante.tipoPessoa == "Jurídica")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
                      initialValue: formatCNPJ(_contratante.cnpj!),
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
                        _contratante.cnpj = value;
                        if (GetUtils.isLengthEqualTo(_contratante.cnpj, 18)) {
                          _contratante.cnpj =
                              _contratante.cnpj!.replaceAll('-', '');
                          _contratante.cnpj =
                              _contratante.cnpj!.replaceAll('.', '');
                          _contratante.cnpj =
                              _contratante.cnpj!.replaceAll('/', '');
                        }
                      },
                    ),
                  ),
                if (_contratante.tipoPessoa == "Física")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: TextFormField(
                      initialValue: _contratante.cpf,
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
                        _contratante.cpf = value!;
                      },
                    ),
                  ),
                if (_contratante.tipoPessoa == "Física")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
                      initialValue: _contratante.nome,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Nome"),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com o Nome.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contratante.nome = value!;
                      },
                    ),
                  ),
                if (_contratante.tipoPessoa == "Jurídica")
                  const SizedBox(height: 8),
                if (_contratante.tipoPessoa == "Jurídica")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
                      initialValue: _contratante.razaoSocial,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Razão Social"),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe a razão social.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contratante.razaoSocial = value!;
                      },
                    ),
                  ),
                if (_contratante.tipoPessoa == "Jurídica")
                  const SizedBox(height: 8),
                if (_contratante.tipoPessoa == "Jurídica")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
                      initialValue: _contratante.nomeFantasia,
                      decoration: const InputDecoration(
                        label: Text("Nome Fantasia"),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o nome fantasia.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _contratante.nomeFantasia = value!;
                      },
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_contratante.tipoPessoa == "Jurídica")
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: _contratante.inscricaoEstadual,
                            maxLength: 14,
                            decoration: const InputDecoration(
                              label: Text("Inscrição Estadual"),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe a inscrição estadual.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _contratante.inscricaoEstadual = value!;
                            },
                          ),
                        ),
                      ),
                    if (_contratante.tipoPessoa == "Jurídica")
                      const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _contratante.telefone,
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            label: Text("Telefone"),
                          ),
                          validator: (value) {
                            value = value!.replaceAll('(', '');
                            value = value.replaceAll(')', '');
                            value = value.replaceAll('-', '');
                            value = GetUtils.removeAllWhitespace(value);
                            if (!GetUtils.isNumericOnly(value!) &&
                                GetUtils.isLengthGreaterOrEqual(10, 11)) {
                              return 'Informe um telefone válido.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _contratante.telefone = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: TextFormField(
                    initialValue: _contratante.email,
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
                      _contratante.email = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _enderecoController,
                    decoration: const InputDecoration(
                      label: Text("Endereço"),
                    ),
                    onTap: () async {
                      await Get.toNamed('/endereco',
                          arguments: _contratante.endereco);
                      _contratante.endereco = storage.read('temp_endereco');
                      storage.remove('temp_endereco');
                      if (_contratante.endereco != null) {
                        _enderecoController.text =
                            "${_contratante.endereco!.rua}, ${_contratante.endereco!.numero} - ${_contratante.endereco!.cidade} / ${_contratante.endereco!.estado}";
                      }
                    },
                  ),
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
                          onPressed: _editContratante,
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
