import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros_list.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/models/pages.dart';
import 'package:fleet_tour/widgets/passageiro/edit_passageiro.dart';
import 'package:fleet_tour/widgets/passageiro/new_passageiro.dart';

class Passageiros extends StatefulWidget {
  const Passageiros({super.key});

  @override
  State<Passageiros> createState() => _PassageirosState();
}

class _PassageirosState extends State<Passageiros> {
  List<Passageiro> _loadedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    print(_loadedItems);
  }

  void _loadItems() async {
    _loadedItems = [];
    final url = Uri.http(ip, 'passageiros');
    print(url);
    final response = await http.get(url);
    print(response.body);
    List<dynamic> listData = json.decode(response.body);
    for (final item in listData) {
      Map<String, dynamic> rest = item;
      _loadedItems.add(
        Passageiro(
          idPassageiro: rest['idPassageiro'],
          nome: rest['nome'],
          rg: rest['rg'],
          orgaoEmissor: rest['orgaoEmissor'],
          tipoCliente: rest['tipoCliente'],
          dataNasc: rest['dataNasc'] != null
              ? DateTime.parse(rest['dataNasc'])
              : null,
        ),
      );
    }
    print("after request");
    print(_loadedItems);
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Passageiro>(
      MaterialPageRoute(
        builder: (context) => const NewPassageiro(),
      ),
    );
  }

  void _editExpense(Passageiro passageiro) async {
    final newItem = await Navigator.of(context).push<Passageiro>(
      MaterialPageRoute(
        builder: (context) => EditPassageiro(passageiro: passageiro),
      ),
    );
  }

  void _removeExpense(Passageiro passageiro) {
    final expenseIndex = _loadedItems.indexOf(passageiro);
    setState(() {
      _loadedItems.remove(passageiro);
    });

    Map<String, String> queryParams = {
      'passageiroId': passageiro.idPassageiro.toString(),
    };

    var passageiroId = passageiro.idPassageiro.toString();

    final url = Uri.http(ip, 'passageiros/$passageiroId');
    final response = http.delete(url);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Passageiro deletado.'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            _loadedItems.insert(expenseIndex, passageiro);
            final url = Uri.http(ip, 'passageiros');
            print(url);
            final body = json.encode(
              {
                'nome': passageiro.nome,
                'rg': passageiro.rg,
                'orgaoEmissor': passageiro.orgaoEmissor,
                'tipoCliente': passageiro.tipoCliente,
                'id_Empresa': 1,
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
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Nenhum passageiro cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = PassageirosList(
        passageiroList: _loadedItems,
        onRemoveExpense: _removeExpense,
        onEditExpense: _editExpense,
      );
    }

    List<String> menuItems = [];

    menuItems.add(Paginas.Funcionarios.toString());
    menuItems.add(Paginas.Passageiros.toString());

    return Scaffold(
      appBar: AppBar(
        actions: [
          const DropdownMenuButton(),
          IconButton(onPressed: _loadItems, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _addItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
