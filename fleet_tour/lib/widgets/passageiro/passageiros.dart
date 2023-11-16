import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/configs/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.get(Uri.http(ip, 'passageiros'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        _loadedItems.add(Passageiro.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  void _addPassageiroCompras() async {
    await Get.toNamed('/passageiros/novo/compras');
    _loadItems();
  }

  void _addPassageiroTurismo() async {
    await Get.toNamed('/passageiros/novo/turismo');
    _loadItems();
  }

  void _editPassageiro(Passageiro passageiro) async {
    if (passageiro.tipoCliente == 'Compras') {
      await Get.toNamed('/passageiros/editar/compras', arguments: passageiro);
    } else {
      await Get.toNamed('/passageiros/editar/turismo', arguments: passageiro);
    }
    _loadItems();
  }

  void _showDeleteConfirmationDialog(Passageiro passageiro) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmação de exclusão'),
        content: const Text('Tem certeza que deseja deletar este passageiro?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.offAll(() => const Passageiros(), transition: Transition.noTransition);
            },
          ),
          TextButton(
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _removePassageiro(passageiro);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _escolherTipoPassageiro() {
    Get.dialog(
      AlertDialog(
        title: const Text('Novo passageiro'),
        content:
            const Text('Escolha o tipo de passageiro que deseja cadastrar'),
        actions: <Widget>[
          TextButton(
              onPressed: () => {Get.back()},
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
            child: const Text(
              'Compras',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _addPassageiroCompras();
            },
          ),
          TextButton(
            child: const Text(
              'Turismo',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _addPassageiroTurismo();
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  void _removePassageiro(Passageiro passageiro) async {
    final passageiroIndex = _loadedItems.indexOf(passageiro);
    setState(() {
      _loadedItems.remove(passageiro);
    });

    var passageiroId = passageiro.idPassageiro.toString();
    var storage = GetStorage();
    final token = await storage.read("token");
    final url = Uri.http(ip, 'passageiros/$passageiroId');
    final response = await http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${token!}"});
    if (response.statusCode == 204) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Passageiro deletado',
        'O passageiro foi deletado com sucesso',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _loadedItems.insert(passageiroIndex, passageiro);
      });
      Get.closeAllSnackbars();
      Get.snackbar(
        'Erro ao deletar passageiro',
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
      child: Text('Nenhum passageiro cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = PassageirosList(
        passageiroList: _loadedItems,
        onRemovePassageiro: _showDeleteConfirmationDialog,
        onEditPassageiro: _editPassageiro,
      );
    }

    return Scaffold(
      appBar: customAppBar(loadItems: _loadItems, addItem: _escolherTipoPassageiro),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
