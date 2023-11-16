import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/configs/custom_app_bar.dart';
import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/models/viagem.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/widgets/viagem/viagem_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Viagens extends StatefulWidget {
  const Viagens({super.key});

  @override
  State<Viagens> createState() => _ViagensState();
}

class _ViagensState extends State<Viagens> {
  List<Viagem> _loadedItems = [];

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
    final response = await http.get(Uri.http(ip, 'viagens'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        _loadedItems.add(Viagem.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  void _cacheDadosNew() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );

    var storage = GetStorage();
    final token = storage.read("token");

    List<Veiculo> veiculos = [];
    var response = await http.get(Uri.http(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        veiculos.add(Veiculo.fromJson(item));
      }
      storage.write("veiculos", veiculos);
    }

    List<Contratante> contratantes = [];
    response = await http.get(Uri.http(ip, 'contratantes'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        contratantes.add(Contratante.fromJson(item));
      }
      storage.write("contratantes", contratantes);
    }

    List<Funcionario> funcionarios = [];
    response = await http.get(Uri.http(ip, 'funcionarios'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        funcionarios.add(Funcionario.fromJson(item));
      }
      storage.write("funcionarios", funcionarios);
    }

    List<Passageiro> passageiros = [];
    response = await http.get(Uri.http(ip, 'passageiros'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        passageiros.add(Passageiro.fromJson(item));
      }
      storage.write("passageiros", passageiros);
    }

    Get.close(1);
    _addItem();
  }

  void _cacheDadosEdit(Viagem viagem) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );

    var storage = GetStorage();
    final token = storage.read("token");

    List<Veiculo> veiculos = [];
    var response = await http.get(Uri.http(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        veiculos.add(Veiculo.fromJson(item));
      }
      storage.write("veiculos", veiculos);
    }

    List<Contratante> contratantes = [];
    response = await http.get(Uri.http(ip, 'contratantes'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        contratantes.add(Contratante.fromJson(item));
      }
      storage.write("contratantes", contratantes);
    }

    List<Funcionario> funcionarios = [];
    response = await http.get(Uri.http(ip, 'funcionarios'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        funcionarios.add(Funcionario.fromJson(item));
      }
      storage.write("funcionarios", funcionarios);
    }

    List<Passageiro> passageiros = [];
    response = await http.get(Uri.http(ip, 'passageiros'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(utf8.decode(response.body.runes.toList()));
      for (var item in body) {
        passageiros.add(Passageiro.fromJson(item));
      }
      storage.write("passageiros", passageiros);
    }

    Get.close(1);
    _editViagem(viagem);
  }

  void _addItem() async {
    await Get.toNamed('/viagens/novo');
    _loadItems();
  }

  void _editViagem(Viagem viagem) async {
    await Get.toNamed('/viagens/editar', arguments: viagem);
    _loadItems();
  }

  void _showDeleteConfirmationDialog(Viagem viagem) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmação de exclusão'),
        content: const Text('Tem certeza que deseja deletar esta viagem?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.offAll(() => const Viagens(), transition: Transition.noTransition);
            },
          ),
          TextButton(
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Get.back();
              _removeViagem(viagem);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _removeViagem(Viagem viagem) async {
    final viagemIndex = _loadedItems.indexOf(viagem);
    setState(() {
      _loadedItems.remove(viagem);
    });
    final viagemId = viagem.idViagem;
    var storage = GetStorage();
    final token = await storage.read("token");
    final url = Uri.http(ip, 'viagens/$viagemId');
    final response = await http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${token!}"});
    if (response.statusCode >= 204) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Viagem deletado',
        'O viagem foi deletado com sucesso',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _loadedItems.insert(viagemIndex, viagem);
      });
      Get.closeAllSnackbars();
      Get.snackbar(
        'Erro ao deletar viagem',
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
      child: Text('Nenhuma viagem cadastrada, inicie cadastrando uma!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = ViagemList(
        viagemList: _loadedItems,
        onRemoveViagem: _showDeleteConfirmationDialog,
        onEditViagem: _cacheDadosEdit,
      );
    }

    return Scaffold(
      appBar: customAppBar(loadItems: _loadItems, addItem: _cacheDadosNew),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
