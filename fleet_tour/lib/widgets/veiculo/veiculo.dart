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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItems();
    });
  }

  void _loadItems() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
    );
    _loadedItems = [];
    var storage = GetStorage();
    final token = storage.read("token");
    final response = await http.get(Uri.http(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(response.body);
      for (var item in body) {
        _loadedItems.add(Veiculo.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  void _addItem() async {
    await Get.toNamed('/veiculos/novo');
    _loadItems();
  }

  void _editVeiculo(Veiculo onibus) async {
    await Get.toNamed('/veiculos/editar', arguments: onibus);
    _loadItems();
  }

  void _showDeleteConfirmationDialog(Veiculo veiculo) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmação de exclusão'),
        content: const Text('Tem certeza que deseja deletar este veículo?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _loadItems();
              Get.back();
            },
          ),
          TextButton(
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _removeVeiculo(veiculo);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _removeVeiculo(Veiculo onibus) async {
    final onibusIndex = _loadedItems.indexOf(onibus);
    setState(() {
      _loadedItems.remove(onibus);
    });

    var onibusid = onibus.idVeiculo.toString();
    var storage = GetStorage();
    final token = await storage.read("token");
    final url = Uri.http(ip, 'veiculos/$onibusid');
    final response = await http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${token!}"});
    if (response.statusCode >= 204) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Veículo deletado',
        'O veículo foi deletado com sucesso',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _loadedItems.insert(onibusIndex, onibus);
      });
      Get.closeAllSnackbars();
      Get.snackbar(
        'Erro ao deletar veículo',
        'Por favor, tente novamente mais tarde',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Nenhum veículo cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = VeiculoList(
        veiculoList: _loadedItems,
        onRemoveVeiculo: _showDeleteConfirmationDialog,
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
