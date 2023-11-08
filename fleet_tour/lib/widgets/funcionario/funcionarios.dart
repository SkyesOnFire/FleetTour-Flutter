import 'dart:convert';
import 'dart:io';

import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/widgets/funcionario/funcionario_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
    final url = Uri.http(ip, 'funcionarios');
    final response =
        await http.get(url, headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 || response.body.isNotEmpty) {
      final body = json.decode(response.body);
      for (var item in body) {
        _loadedItems.add(Funcionario.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  void _addItem() async {
    await Get.toNamed('/funcionario/novo');
    _loadItems();
  }

  void _editFuncionario(Funcionario funcionario) async {
    await Get.toNamed('/funcionarios/editar', arguments: funcionario);
    _loadItems();
  }

  void _showDeleteConfirmationDialog(Funcionario funcionario) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmação de exclusão'),
        content: const Text('Tem certeza que deseja deletar este funcionário?'),
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
              _removeFuncionario(funcionario);
            },
          ),
        ],
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  void _removeFuncionario(Funcionario funcionario) async {
    final funcionarioIndex = _loadedItems.indexOf(funcionario);
    setState(() {
      _loadedItems.remove(funcionario);
    });

    var funcionarioId = funcionario.idFuncionario.toString();
    var storage = GetStorage();
    final token = await storage.read("token");
    final url = Uri.http(ip, 'funcionarios/$funcionarioId');
    final response = await http.delete(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${token!}"});
    if (response.statusCode == 204) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Funcionário deletado',
        'O funcionário foi deletado com sucesso',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _loadedItems.insert(funcionarioIndex, funcionario);
      });
      Get.closeAllSnackbars();
      Get.snackbar(
        'Erro ao deletar funcionário',
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
      child: Text('Nenhum funcionário cadastrado, inicie cadastrando um!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = FuncionariosList(
        funcionarios: _loadedItems,
        onDelete: _showDeleteConfirmationDialog,
        onEdit: _editFuncionario,
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
