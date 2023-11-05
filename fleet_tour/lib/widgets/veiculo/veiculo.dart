import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/veiculo/veiculo_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
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
    var storage = GetStorage();
    final token = storage.read("token");
    print(token);
    final response = await http.get(Uri.http(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(response.body);
      for (var item in body) {
        _loadedItems.add(Veiculo.fromJson(item));
      }
    }
    setState(() {});
  }

  void _addItem() {
    Get.toNamed('/new/vehicle');
  }

  void _editVeiculo(Veiculo onibus) {
    Get.toNamed('edit/vehicles', arguments: onibus);
  }

  void _removeVeiculo(Veiculo onibus) {
    final onibusIndex = _loadedItems.indexOf(onibus);
    setState(() {
      _loadedItems.remove(onibus);
    });

    var onibusid = onibus.idVeiculo.toString();

    final url = Uri.http(ip, 'veiculos/$onibusid');
    final response = http.delete(url);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Veículo deletado.'),
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
                  'quilometragem': onibus.quilometragem,
                  'codFrota': onibus.codFrota,
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
