import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/data/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Atualize com o seu modelo

class EditFuncionario extends StatefulWidget {
  const EditFuncionario({Key? key}) : super(key: key);

  @override
  _EditFuncionarioState createState() => _EditFuncionarioState();
}

class _EditFuncionarioState extends State<EditFuncionario> {
  final _formKey = GlobalKey<FormState>();
  final Funcionario _funcionario = Get.arguments;
  final MaskTextInputFormatter rgMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###-#', // This is the mask for the RG format.
    filter: {"#": RegExp(r'[0-9Xx]')}, // RG can end with a number or 'X'/'x'.
  );

  @override
  void initState() {
    super.initState();
  }

  void _saveItem() async {
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
      final url = Uri.http(ip, 'funcionarios/${_funcionario.idFuncionario}');
      var bodyBeforeJson = _funcionario.toJson();

      final body = json.encode(bodyBeforeJson);
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
          'Funcionário editado com sucesso.',
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
          'Erro ao editar funcionário.',
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
        title: const Text("Editar funcionário"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _funcionario.funcao,
                  items: ['Motorista', 'Guia'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration:
                      const InputDecoration(labelText: 'Função do funcionário'),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma funcão para o funcionário';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _funcionario.funcao = value;
                  },
                ),
                TextFormField(
                  initialValue: _funcionario.nome,
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
                  initialValue: _funcionario.cpf,
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
                  initialValue: _funcionario.telefone,
                  decoration: const InputDecoration(label: Text("Telefone")),
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  onSaved: (value) => _funcionario.telefone = value,
                ),
                DropdownButtonFormField(
                  value: _funcionario.genero,
                  items: ['Masculino', 'Feminino', 'Outro'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (value) {
                    if (value == null) {
                      return 'Escolha um gênero';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _funcionario.genero = value;
                  },
                ),
                TextFormField(
                  initialValue: _funcionario.rg,
                  decoration: const InputDecoration(label: Text("RG")),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    rgMaskFormatter,
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
                  initialValue: _funcionario.cnh,
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
                  initialValue: formatDateForInput(_funcionario.dataNasc),
                  validator: (value) {
                    if (!GetUtils.isLengthEqualTo(value, 10)) {
                      return 'Informe a data de nascimento';
                    }
                    return null;
                  },
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
                  initialValue: formatDateForInput(_funcionario.vencimentoCnh),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      value = value.replaceAll('/', '-');
                      var splitValue = value.split('-');
                      value =
                          '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                    }
                    if (!GetUtils.isLengthEqualTo(value, 10)) {
                      return 'Informe a data vencimento da CNH';
                    }
                    return null;
                  },
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
                  initialValue:
                      formatDateForInput(_funcionario.vencimentoCartSaude),
                  validator: (value) {
                    if (!GetUtils.isLengthEqualTo(value, 10)) {
                      return 'Informe a data vencimento do cartão de saúde';
                    }
                    return null;
                  },
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
                        onPressed: () => Get.close(1),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text('Salvar'),
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
