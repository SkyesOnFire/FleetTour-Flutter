import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/configs/custom_app_bar.dart';
import 'package:fleet_tour/models/contratante.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/contratante/contratante_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Contratantes extends StatefulWidget {
  const Contratantes({super.key});

  @override
  State<Contratantes> createState() => _ContratantesState();
}

class _ContratantesState extends State<Contratantes> {
  List<Contratante> _loadedItems = [];

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
    final response = await http.get(Uri.http(ip, 'contratantes'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        _loadedItems.add(Contratante.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  void _addItem() async {
    await Get.toNamed('/contratantes/novo');
    _loadItems();
  }

  void _editContratante(Contratante contratante) async {
    await Get.toNamed('/contratantes/editar', arguments: contratante);
    _loadItems();
  }

  void _showDeleteConfirmationDialog(Contratante contratante) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmação de exclusão'),
        content: const Text('Tem certeza que deseja deletar este contratante?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.offAll(() => const Contratantes(), transition: Transition.noTransition);
            },
          ),
          TextButton(
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _removeContratante(contratante);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _removeContratante(Contratante contratante) async {
    final contratanteIndex = _loadedItems.indexOf(contratante);
    setState(() {
      _loadedItems.remove(contratante);
    });
    final contratanteId = contratante.idContratante;
    var storage = GetStorage();
    final token = await storage.read("token");
    final url = Uri.http(ip, 'contratantes/$contratanteId');
    final response = await http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${token!}"});
    if (response.statusCode >= 204) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Contratante deletado',
        'O contratante foi deletado com sucesso',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _loadedItems.insert(contratanteIndex, contratante);
      });
      Get.closeAllSnackbars();
      Get.snackbar(
        'Erro ao deletar contratante',
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
      child: Text('Nenhum contratante cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = ContratanteList(
        contratanteList: _loadedItems,
        onRemoveContratante: _showDeleteConfirmationDialog,
        onEditContratante: _editContratante,
      );
    }

    return Scaffold(
      appBar: customAppBar(loadItems: _loadItems, addItem: _addItem),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
