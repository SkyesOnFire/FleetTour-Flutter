import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/onibus.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/onibus/onibus_list.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/widgets/onibus/new_onibus.dart';
import 'package:fleet_tour/models/category.dart';
import 'package:fleet_tour/widgets/onibus/edit_onibus.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Onibus> _loadedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    print(_loadedItems);
  }

  void _loadItems() async {
    _loadedItems = [];
    final url = Uri.http(ip, 'veiculos');
    print(url);
    final response = await http.get(url);
    print(response.body);
    List<dynamic> listData = json.decode(response.body);
    for (final item in listData) {
      Map<String, dynamic> rest = item;
      _loadedItems.add(
        Onibus(
          id: rest['idVeiculo'],
          placa: rest["placa"],
          renavam: rest['renavam'],
          ano: rest['ano'],
          km: rest['quilometragem'],
          numeroFrota: rest['codFrota'],
          capacidade: rest['capacidade'],
          taf: rest['taf'],
          regEstadual: rest['regEstadual'],
        ),
      );
    }
    print("apos request");
    print(_loadedItems);
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Onibus>(
      MaterialPageRoute(
        builder: (context) => const NewOnibus(),
      ),
    );
  }

  void _editExpense(Onibus onibus) async {
    final newItem = await Navigator.of(context).push<Onibus>(
      MaterialPageRoute(
        builder: (context) => EditOnibus(onibus: onibus),
      ),
    );
  }

  void _removeExpense(Onibus onibus) {
    final expenseIndex = _loadedItems.indexOf(onibus);
    setState(() {
      _loadedItems.remove(onibus);
    });

    Map<String, String> uParams = {
      'veiculoId': onibus.id.toString(),
    };

    var onibusid = onibus.id.toString();

    final url = Uri.http(ip, 'veiculos/$onibusid');
    final response = http.delete(url);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Onibus deletado.'),
      action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _loadedItems.insert(expenseIndex, onibus);
              final url = Uri.http(ip, 'veiculos');
              print(url);
              final body = json.encode(
                {
                  'placa': onibus.placa,
                  'renavam': onibus.renavam,
                  'ano': onibus.ano,
                  'quilometragem': onibus.km,
                  'codFrota': onibus.numeroFrota,
                  'capacidade': onibus.capacidade,
                  'taf': onibus.taf,
                  'regEstadual': onibus.regEstadual,
                  "id_Empresa": 1
                },
              );
              print(body);
              final response = http.post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                },
                body: body,
              );
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Nenhum veículo cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = ExpensesList(
        onibusList: _loadedItems,
        onRemoveExpense: _removeExpense,
        onEditExpense: _editExpense,
      );
    }

    List<String> menuItems = [];

    menuItems.add(Paginas.Funcionarios.toString());
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
