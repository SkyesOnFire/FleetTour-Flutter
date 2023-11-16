import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/models/viagem.dart';
import 'package:fleet_tour/widgets/contratante/contratante_list_picker.dart';
import 'package:fleet_tour/widgets/funcionario/funcionarios_list_picker.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros_list_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewViagem extends StatefulWidget {
  const NewViagem({super.key});

  @override
  State<NewViagem> createState() {
    return _NewViagemState();
  }
}

class _NewViagemState extends State<NewViagem> {
  final storage = GetStorage();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contratanteController = TextEditingController();
  final TextEditingController _funcionarioController = TextEditingController();
  final TextEditingController _passageiroController = TextEditingController();

  List<Contratante> _selectedContratantes = [];
  List<Funcionario> _selectedFuncionarios = [];
  List<Passageiro> _selectedPassageiros = [];
  final Viagem _viagem = Viagem();

  void _saveViagem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 500),
      );

      _viagem.contratante = _selectedContratantes.first;
      _viagem.funcionarios = _selectedFuncionarios;
      _viagem.passageiros = _selectedPassageiros;

      final url = Uri.http(ip, 'viagens');
      var storage = GetStorage();
      final token = storage.read("token");
      final body = jsonEncode(_viagem.toJson());
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
          'Viagem cadastrado com sucesso',
          'Você será redirecionado para a tela de viagens',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.close(1);
      } else {
        Get.close(1);
        Get.closeAllSnackbars();
        Get.snackbar(
          'Erro ao cadastrar viagem',
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
    final MaskTextInputFormatter rgMaskFormatter = MaskTextInputFormatter(
      mask: '000000-00',
    );

    final List<Funcionario> funcionarios = storage.read('funcionarios');
    final List<Contratante> contratantes = storage.read('contratantes');
    final List<Veiculo> veiculos = storage.read('veiculos');
    final List<Passageiro> passageiros = storage.read('passageiros');

    void showFuncionariosModal() async {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FuncionarioListPicker(
            funcionarios: funcionarios,
            selectedFuncionarios: _selectedFuncionarios,
          );
        },
      );
      setState(() {
        _selectedFuncionarios = storage.read('selectedFuncionarios') ?? [];
        _funcionarioController.clear();
        if (_selectedFuncionarios.isNotEmpty) {
          _funcionarioController.text = _selectedFuncionarios.first.nome!;
        }
      });
    }

    void showContratanteModal() async {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ContratanteListPicker(
            contratantes: contratantes,
            selectedContratantes: _selectedContratantes,
          );
        },
      );
      setState(() {
        _selectedContratantes = storage.read('selectedContratantes') ?? [];
        _contratanteController.clear();
        if (_selectedContratantes.isNotEmpty) {
          _contratanteController.text = _selectedContratantes.first.nome ??
              _selectedContratantes.first.nomeFantasia!;
        }
      });
    }

    void showPassageirosModal() async {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PassageiroListPicker(
            passageiros: passageiros,
            selectedPassageiros: _selectedPassageiros,
          );
        },
      );
      setState(() {
        _selectedPassageiros = storage.read('selectedPassageiros') ?? [];
        _passageiroController.clear();
        if (_selectedPassageiros.isNotEmpty) {
          if (_selectedPassageiros.length == 1) {
            _passageiroController.text =
                "${_selectedPassageiros.length.toString()} passageiro selecionado.";
          } else {
            _passageiroController.text =
                "${_selectedPassageiros.length.toString()} passageiros selecionados.";
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar nova viagem"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(label: Text("Data da viagem")),
                    onSaved: (value) {
                      if (GetUtils.isLengthEqualTo(value, 10)) {
                        value = value!.replaceAll('/', '-');
                        var splitValue = value.split('-');
                        value =
                            '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                        _viagem.dataViagem = DateTime.parse(value);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter(),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        value = value.replaceAll('/', '-');
                        var splitValue = value.split('-');
                        value =
                            '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                      }
                      if (!GetUtils.isLengthEqualTo(value, 10)) {
                        return 'Informe a data da viagem';
                      }
                      return null;
                    },
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: TextFormField(
                //           decoration: const InputDecoration(
                //               label: Text("Hora de Saída")),
                //           onSaved: (value) {
                //             if (GetUtils.isLengthEqualTo(value, 10)) {
                //               value = value!.replaceAll('/', '-');
                //               var splitValue = value.split('-');
                //               value =
                //                   '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                //               _viagem.horaSaida = DateTime.parse(value);
                //             }
                //           },
                //           inputFormatters: [
                //             FilteringTextInputFormatter.digitsOnly,
                //             DataInputFormatter(),
                //           ],
                //           validator: (value) {
                //             if (!GetUtils.isLengthEqualTo(value, 10)) {
                //               return 'Informe a data de saída';
                //             }
                //             return null;
                //           },
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: TextFormField(
                //           decoration: const InputDecoration(
                //               label: Text("Hora de Chegada (Origem)")),
                //           onSaved: (value) {
                //             if (GetUtils.isLengthEqualTo(value, 10)) {
                //               value = value!.replaceAll('/', '-');
                //               var splitValue = value.split('-');
                //               value =
                //                   '${splitValue[2]}-${splitValue[1]}-${splitValue[0]}';
                //               _viagem.horaChegada = DateTime.parse(value);
                //             }
                //           },
                //           inputFormatters: [
                //             FilteringTextInputFormatter.digitsOnly,
                //             DataInputFormatter(),
                //           ],
                //           validator: (value) {
                //             if (!GetUtils.isLengthEqualTo(value, 10)) {
                //               return 'Informe a data de saída';
                //             }
                //             return null;
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonFormField(
                    items: ['Confirmada', 'À confirmar', 'Cotação']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _viagem.status = value;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Status da viagem'),
                    validator: (value) {
                      if (value == null) {
                        return 'Informe o status da viagem.';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            RealInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            label: Text("Valor do frete (R\$)"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com o valor do frete.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            value = value!.replaceAll('.', '');
                            _viagem.valor = double.parse(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            KmInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            label: Text("Quilometragem"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com a quilometragem.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            value = value!.replaceAll('.', '');
                            _viagem.km = double.parse(value);
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
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Origem (Cidade-UF)"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com a origem da viagem.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _viagem.origem = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Destino (Cidade-UF)"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com o destino da viagem.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _viagem.destino = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 15,
                          decoration: const InputDecoration(
                            label: Text("NFe"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com a NFe.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _viagem.nfe = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            RealInputFormatter(),
                          ],
                          decoration: const InputDecoration(
                            label: Text("Valor da NFe (R\$)"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com o valor da NFe.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            value = value!.replaceAll('.', '');
                            _viagem.valorNfe = double.parse(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField(
                    items: veiculos
                        .map<DropdownMenuItem<Veiculo>>((Veiculo veiculo) {
                      return DropdownMenuItem<Veiculo>(
                          value: veiculo,
                          child: Text(
                              'Placa ${veiculo.placa} | ${veiculo.codFrota} | ${veiculo.capacidade} Lugares'));
                    }).toList(),
                    onChanged: (value) {
                      _viagem.veiculo = value;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Veículo fretado'),
                    validator: (value) {
                      if (value == null) {
                        return 'Informe o veículo.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _contratanteController,
                          decoration: const InputDecoration(
                            label: Text("Contratante"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com o contratante.';
                            }
                            return null;
                          },
                          onTap: () {
                            showContratanteModal();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _funcionarioController,
                          decoration: const InputDecoration(
                            label: Text("Motoristas / Guias"),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Selecione um funcionário.';
                            }
                            return null;
                          },
                          onTap: () {
                            showFuncionariosModal();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passageiroController,
                    decoration: const InputDecoration(
                      label: Text("Passageiros"),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entre com os passageiros.';
                      }
                      return null;
                    },
                    onTap: () {
                      showPassageirosModal();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      label: Text("Observações"),
                    ),
                    onSaved: (value) {
                      _viagem.observacao = value;
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
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Limpar')),
                      ElevatedButton(
                          onPressed: _saveViagem,
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
