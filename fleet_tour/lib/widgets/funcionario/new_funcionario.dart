import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart'; // Update with your server config
import 'package:fleet_tour/models/funcionario.dart'; // Update with your model

class NewFuncionario extends StatefulWidget {
  const NewFuncionario({super.key});

  @override
  State<NewFuncionario> createState() => _NewFuncionarioState();
}

class _NewFuncionarioState extends State<NewFuncionario> {
  final _formKey = GlobalKey<FormState>();
  var _enteredFuncao = '';
  var _enteredNome = '';
  var _enteredCpf = '';
  var _enteredTelefone = '';
  var _enteredGenero = '';
  var _enteredRg = '';
  var _enteredCnh = '';
  DateTime _enteredDataNasc = DateTime.now();
  DateTime? _enteredVencimentoCnh;
  DateTime? _enteredVencimentoCartSaude;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(now.year - 20),
        firstDate: DateTime(1950),
        lastDate: DateTime(now.year));
    setState(() {
      _enteredDataNasc = pickedDate!;
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.http(ip, 'funcionarios');
      final body = json.encode(
        {
          'funcao': _enteredFuncao,
          'nome': _enteredNome,
          'cpf': _enteredCpf,
          'telefone': _enteredTelefone,
          'genero': _enteredGenero,
          'rg': _enteredRg,
          'cnh': _enteredCnh,
          'dataNasc': _enteredDataNasc.toIso8601String(),
          'vencimentoCnh': _enteredVencimentoCnh?.toIso8601String(),
          'vencimentoCartSaude': _enteredVencimentoCartSaude?.toIso8601String(),
        },
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
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
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Função"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma função';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredFuncao = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Nome"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredNome = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("CPF"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um CPF';
                    }
                    if (!RegExp(r"^\d{11}$").hasMatch(value)) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredCpf = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Telefone"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um telefone';
                    }
                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredTelefone = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Gênero"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um gênero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredGenero = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("RG"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um RG';
                    }
                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                      return 'RG inválido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredRg = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("CNH"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira uma CNH';
                    }
                    if (!RegExp(r"^\d+$").hasMatch(value)) {
                      return 'CNH inválida';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredCnh = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Data de Nascimento:     '),
                    Text(_enteredDataNasc == null
                        ? 'Nenhuma data selecionada'
                        : _enteredDataNasc.year.toString() +
                            '/' +
                            _enteredDataNasc.month.toString() +
                            '/' +
                            _enteredDataNasc.day.toString()),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Salvar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
