import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/funcionario.dart'; // Atualize com o seu modelo

class EditFuncionario extends StatefulWidget {
  final Funcionario funcionario;

  EditFuncionario({required this.funcionario});

  @override
  _EditFuncionarioState createState() => _EditFuncionarioState();
}

class _EditFuncionarioState extends State<EditFuncionario> {
  final _formKey = GlobalKey<FormState>();
  late String _editedFuncao;
  late String _editedNome;
  late String _editedCpf;
  late String _editedTelefone;
  late String _editedGenero;
  late String _editedRg;
  late String _editedCnh;
  late DateTime _editedDataNasc;
  late DateTime? _editedVencimentoCnh;
  late DateTime? _editedVencimentoCartSaude;

  @override
  void initState() {
    super.initState();
    _editedFuncao = widget.funcionario.funcao;
    _editedNome = widget.funcionario.nome;
    _editedCpf = widget.funcionario.cpf;
    _editedTelefone = widget.funcionario.telefone;
    _editedGenero = widget.funcionario.genero;
    _editedRg = widget.funcionario.rg;
    _editedCnh = widget.funcionario.cnh;
    _editedDataNasc = widget.funcionario.dataNasc;
    _editedVencimentoCnh = widget.funcionario.vencimentoCnh;
    _editedVencimentoCartSaude = widget.funcionario.vencimentoCartSaude;
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final updatedFuncionario = Funcionario(
      id: widget.funcionario.id,
      funcao: widget.funcionario.funcao,
      nome: widget.funcionario.nome,
      cpf: widget.funcionario.cpf,
      telefone: widget.funcionario.telefone,
      genero: widget.funcionario.genero,
      rg: widget.funcionario.rg,
      cnh: widget.funcionario.cnh,
      dataNasc: widget.funcionario.dataNasc,
      vencimentoCnh: widget.funcionario.vencimentoCnh,
      vencimentoCartSaude: widget.funcionario.vencimentoCartSaude,
    );

    // Aqui, você pode fazer a chamada para a API para atualizar o funcionário
    final url = Uri.http(ip, 'funcionarios/${widget.funcionario.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedFuncionario
          .toMap()), // Suponha que você tenha um método toMap no seu modelo
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Funcionário'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _editedNome,
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) {
                  _editedNome = value!;
                },
              ),
              TextFormField(
                initialValue: _editedFuncao,
                decoration: InputDecoration(labelText: 'Função'),
                onSaved: (value) {
                  _editedFuncao = value!;
                },
              ),
              TextFormField(
                initialValue: _editedCpf,
                decoration: InputDecoration(labelText: 'CPF'),
                onSaved: (value) {
                  _editedCpf = value!;
                },
              ),
              TextFormField(
                initialValue: _editedTelefone,
                decoration: InputDecoration(labelText: 'Telefone'),
                onSaved: (value) {
                  _editedTelefone = value!;
                },
              ),
              TextFormField(
                initialValue: _editedGenero,
                decoration: InputDecoration(labelText: 'Gênero'),
                onSaved: (value) {
                  _editedGenero = value!;
                },
              ),
              TextFormField(
                initialValue: _editedRg,
                decoration: InputDecoration(labelText: 'RG'),
                onSaved: (value) {
                  _editedRg = value!;
                },
              ),
              TextFormField(
                initialValue: _editedCnh,
                decoration: InputDecoration(labelText: 'CNH'),
                onSaved: (value) {
                  _editedCnh = value!;
                },
              ),
              // Adicione um widget para selecionar a data de nascimento aqui
              // Adicione um widget para selecionar a data de vencimento da CNH aqui
              // Adicione um widget para selecionar a data de vencimento do cartão de saúde aqui
            ],
          ),
        ),
      ),
    );
  }
}
