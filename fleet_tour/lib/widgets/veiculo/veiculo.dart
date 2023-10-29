import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/veiculo/veiculo_list.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/widgets/veiculo/new_veiculo.dart';
import 'package:fleet_tour/models/pages.dart';
import 'package:fleet_tour/widgets/veiculo/edit_veiculo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Veiculos extends StatefulWidget {
  const Veiculos({super.key});

  @override
  State<Veiculos> createState() => _VeiculosState();
}

class _VeiculosState extends State<Veiculos> {
  List<Veiculo> _loadedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    _loadedItems = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Sessão expirada, por favor, realize o login novamente.'),
        ),
      );
      Navigator.of(context).pushReplacementNamed('/');
    }
    final response = await http.get(Uri.https(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    List<dynamic> listData = json.decode(response.body);
    for (final item in listData) {
      Map<String, dynamic> rest = item;
      _loadedItems.add(
        Veiculo(
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
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Veiculo>(
      MaterialPageRoute(
        builder: (context) => const NewVeiculo(),
      ),
    );
  }

  void _editVeiculo(Veiculo onibus) async {
    final newItem = await Navigator.of(context).push<Veiculo>(
      MaterialPageRoute(
        builder: (context) => EditVeiculo(veiculo: onibus),
      ),
    );
  }

  void _removeVeiculo(Veiculo onibus) {
    final onibusIndex = _loadedItems.indexOf(onibus);
    setState(() {
      _loadedItems.remove(onibus);
    });

    var onibusid = onibus.id.toString();

    final url = Uri.http(ip, 'veiculos/$onibusid');
    final response = http.delete(url);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Veiculo deletado.'),
      action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _loadedItems.insert(onibusIndex, onibus);
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
      mainContent = VeiculoList(
        veiculoList: _loadedItems,
        onRemoveVeiculo: _removeVeiculo,
        onEditVeiculo: _editVeiculo,
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
