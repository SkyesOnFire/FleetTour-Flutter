import 'dart:convert';

import 'package:fleet_tour/models/category.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart'; // Update with your server config
import 'package:fleet_tour/models/funcionario.dart'; // Update with your model
import 'package:fleet_tour/widgets/funcionario/new_funcionario.dart';
import 'package:fleet_tour/widgets/funcionario/edit_funcionario.dart';
import 'package:fleet_tour/widgets/funcionario/funcionario_list.dart';
import 'package:http/http.dart' as http;

class Funcionarios extends StatefulWidget {
  const Funcionarios({super.key});

  @override
  State<Funcionarios> createState() => _FuncionariosState();
}

class _FuncionariosState extends State<Funcionarios> {
  List<Funcionario> _loadedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    _loadedItems = [];
    final url = Uri.http(ip, 'funcionarios');
    final response = await http.get(url);
    List<dynamic> listData = json.decode(response.body);
    for (final item in listData) {
      Map<String, dynamic> rest = item;
      _loadedItems.add(
        Funcionario(
          id: rest['idFuncionario'],
          funcao: rest['funcao'],
          nome: rest['nome'],
          cpf: rest['cpf'],
          telefone: rest['telefone'],
          genero: rest['genero'],
          rg: rest['rg'],
          cnh: rest['cnh'],
          dataNasc: DateTime.parse(rest['dataNasc']),
          vencimentoCnh: rest['vencimentoCnh'] != null
              ? DateTime.parse(rest['vencimentoCnh'])
              : null,
          vencimentoCartSaude: rest['vencimentoCartSaude'] != null
              ? DateTime.parse(rest['vencimentoCartSaude'])
              : null,
        ),
      );
    }
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Funcionario>(
      MaterialPageRoute(
        builder: (context) => const NewFuncionario(),
      ),
    );
    if (newItem != null) {
      setState(() {
        _loadedItems.add(newItem);
      });
    }
  }

  void _editFuncionario(Funcionario funcionario) async {
    final editedItem = await Navigator.of(context).push<Funcionario>(
      MaterialPageRoute(
        builder: (context) => EditFuncionario(funcionario: funcionario),
      ),
    );
    if (editedItem != null) {
      setState(() {
        final index =
            _loadedItems.indexWhere((item) => item.id == editedItem.id);
        _loadedItems[index] = editedItem;
      });
    }
  }

  void _removeFuncionario(Funcionario funcionario) {
    setState(() {
      _loadedItems.removeWhere((item) => item.id == funcionario.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Nenhum funcionário cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = FuncionariosList(
        funcionarios: _loadedItems,
        onDelete: _removeFuncionario,
        onEdit: _editFuncionario,
      );
    }

    List<String> menuItems = [];

    menuItems.add(Paginas.Frota.toString());
    menuItems.add(Paginas.Passageiros.toString());
    menuItems.add(Paginas.Empresa.toString());

    return Scaffold(
      appBar: AppBar(
        actions: [
          const DropdownMenuButton(),
          IconButton(onPressed: _loadItems, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
