import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/data/validationUtils.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NewFuncionario extends StatefulWidget {
  const NewFuncionario({super.key});

  @override
  _NewFuncionarioState createState() => _NewFuncionarioState();
}

class _NewFuncionarioState extends State<NewFuncionario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Funcionario _funcionario = Funcionario();

  void _saveFuncionario() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 2),
      );

      var storage = GetStorage();
      final token = storage.read("token");
      final url = Uri.http(ip, 'funcionarios');
      final response = await http.post(url,
          headers: {
            'authorization': "Bearer ${token!}",
            'Content-Type': 'application/json'
          },
          body: json.encode(_funcionario.toJson()));

      if (!context.mounted) {
        return;
      }

      if (response.statusCode == 201) {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Funcionário cadastrado com sucesso',
          'Você será redirecionado para a lista de funcionários',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Erro ao cadastrar funcionário',
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
        title: const Text("Cadastrar novo funcionário"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  items: ['Motorista', 'Guia'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _funcionario.funcao = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Função do funcionário'),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma funcão para o funcionário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Nome")),
                  onSaved: (value) => _funcionario.nome = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite o nome do funcionário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("CPF")),
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  onSaved: (value) => _funcionario.cpf = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite o CPF do funcionário';
                    }
                    if (!CPFValidator.isValid(value)) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Telefone")),
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  onSaved: (value) => _funcionario.telefone = value,
                ),
                DropdownButtonFormField(
                  items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _funcionario.genero = value;
                  },
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (value) {
                    if (value == null) {
                      return 'Escolha um gênero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("RG")),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    BrazilianRgInputFormatter(),
                  ],
                  onSaved: (value) => _funcionario.rg = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite o RG do funcionário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text("CNH")),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onSaved: (value) => _funcionario.cnh = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite a CNH do funcionário';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text("Data de Nascimento")),
                  onSaved: (value) {
                    if (GetUtils.isLengthEqualTo(value, 10)) {
                      value = value!.replaceAll('/', '-');
                      var splitValue = value.split('-');
                      value =
                          '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                      _funcionario.dataNasc = DateTime.parse(value);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text("Vencimento da CNH")),
                  onSaved: (value) {
                    if (GetUtils.isLengthEqualTo(value, 10)) {
                      value = value!.replaceAll('/', '-');
                      var splitValue = value.split('-');
                      value =
                          '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                      _funcionario.vencimentoCnh = DateTime.parse(value);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Vencimento Cartão Saúde")),
                  onSaved: (value) {
                    if (GetUtils.isLengthEqualTo(value, 10)) {
                      value = value!.replaceAll('/', '-');
                      var splitValue = value.split('-');
                      value =
                          '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                      _funcionario.vencimentoCartSaude = DateTime.parse(value);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _formKey.currentState!.reset(),
                        child: const Text('Limpar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveFuncionario,
                        child: const Text('Cadastrar'),
                      ),
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
