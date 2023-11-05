import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Endereco _endereco = Get.arguments;
  final Empresa _empresa = Empresa();
  final TextEditingController _nomeFantasiaController = TextEditingController();
  final TextEditingController _razaoSocialController = TextEditingController();
  final TextEditingController _foneEmpresaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _consultarCnpj() async {
    if (_empresa.cnpj!.length == 14) {
      final cnpj = _empresa.cnpj!.trim();
      final cnpjCheckUrl = Uri.http(ip, 'empresas/cnpj/$cnpj');
      final cnpjCheckResponse = await http.get(cnpjCheckUrl);
      print(cnpjCheckResponse.statusCode);
      if (cnpjCheckResponse.body != 'false') {
        Get.closeAllSnackbars();
        Get.snackbar(
          'CNPJ já cadastrado',
          'Por favor, informe um CNPJ válido',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      final url = Uri.https("brasilapi.com.br", '/api/cnpj/v1/$cnpj');
      final response = await http.get(url);
      final body = json.decode(response.body);
      if (!body.containsKey('erro')) {
        if (body['descricao_situacao_cadastral'] != 'ATIVA') {
          Get.closeAllSnackbars();
          Get.snackbar(
            'CNPJ não ativo',
            'Por favor, informe um CNPJ válido',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        _empresa.nomeFantasia = body['nome_fantasia'];
        _empresa.razaoSocial = body['razao_social'];
        _empresa.foneEmpresa = body['ddd_telefone_1'] ?? ['ddd_telefone_2'];
        _empresa.email = body['email'];

        _nomeFantasiaController.text = _empresa.nomeFantasia ?? '';
        _razaoSocialController.text = _empresa.razaoSocial ?? '';
        _foneEmpresaController.text = _empresa.foneEmpresa ?? '';
        _emailController.text = _empresa.email ?? '';
      } else {
        Get.closeAllSnackbars();
        Get.snackbar(
          'CNPJ não encontrado',
          'Por favor, informe um CNPJ válido',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void nextRegisterScreen(Empresa empresa) async {
    
    Get.toNamed('/register/user', arguments: _empresa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados da Empresa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
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
                    _empresa.cnpj = value!;
                    if (GetUtils.isLengthEqualTo(_empresa.cnpj, 18)) {
                      _empresa.cnpj = _empresa.cnpj!.replaceAll('-', '');
                      _empresa.cnpj = _empresa.cnpj!.replaceAll('.', '');
                      _empresa.cnpj = _empresa.cnpj!.replaceAll('/', '');
                      if (!GetUtils.isNumericOnly(_empresa.cnpj!)) {
                        Get.closeAllSnackbars();
                        Get.snackbar(
                          'CNPJ não encontrado',
                          'Por favor, informe um CNPJ válido',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        _consultarCnpj();
                      }
                    }
                  },
                ),
                TextFormField(
                  controller: _nomeFantasiaController,
                  decoration: const InputDecoration(labelText: 'Nome Fantasia'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o Nome Fantasia';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.nomeFantasia = value;
                  },
                ),
                TextFormField(
                  controller: _razaoSocialController,
                  decoration: const InputDecoration(labelText: 'Razão Social'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a Razão Social';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.razaoSocial = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Inscrição Municipal',
                    hintText: 'Somente números',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a Inscrição Municipal';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.inscricaoMunicipal = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Inscrição Estadual',
                    hintText: 'Somente números',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a Inscrição Estadual';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.inscricaoEstadual = value;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o E-mail';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.email = value;
                  },
                ),
                TextFormField(
                  controller: _foneEmpresaController,
                  maxLength: 15,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!GetUtils.isLengthGreaterOrEqual(value, 14)) {
                      return 'Informe o Telefone';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.foneEmpresa = value;
                    if (GetUtils.isLengthGreaterOrEqual(
                        _empresa.foneEmpresa, 14)) {
                      _empresa.foneEmpresa =
                          _empresa.foneEmpresa!.replaceAll('-', '');
                      _empresa.foneEmpresa =
                          _empresa.foneEmpresa!.replaceAll('(', '');
                      _empresa.foneEmpresa =
                          _empresa.foneEmpresa!.replaceAll(')', '');
                      _empresa.foneEmpresa =
                          GetUtils.removeAllWhitespace(_empresa.foneEmpresa!);
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nome Responsável'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o Nome do Responsável';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.nomeResponsavel = value;
                  },
                ),
                TextFormField(
                  maxLength: 15,
                  decoration:
                      const InputDecoration(labelText: 'Telefone Responsável'),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!GetUtils.isLengthGreaterOrEqual(value, 14)) {
                      return 'Informe o Telefone do Responsável';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.foneResponsavel = value;
                    if (GetUtils.isLengthGreaterOrEqual(
                        _empresa.foneResponsavel, 14)) {
                      _empresa.foneResponsavel =
                          _empresa.foneResponsavel!.replaceAll('-', '');
                      _empresa.foneResponsavel =
                          _empresa.foneResponsavel!.replaceAll('(', '');
                      _empresa.foneResponsavel =
                          _empresa.foneResponsavel!.replaceAll(')', '');
                      _empresa.foneResponsavel = GetUtils.removeAllWhitespace(
                          _empresa.foneResponsavel!);
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'E-mail Responsável'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o E-mail do Responsável';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _empresa.emailResponsavel = value;
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
                            _empresa.endereco = _endereco;
                            nextRegisterScreen(_empresa);
                          }
                        },
                        child: const Text('Continuar Cadastro')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
