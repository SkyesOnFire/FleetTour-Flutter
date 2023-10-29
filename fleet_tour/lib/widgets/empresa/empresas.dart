import 'dart:convert';

import 'package:fleet_tour/models/pages.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/widgets/empresa/empresa_list.dart';
import 'package:fleet_tour/widgets/empresa/edit_empresa.dart';
import 'package:fleet_tour/widgets/empresa/new_empresa.dart';
import 'package:http/http.dart' as http;

class Empresas extends StatefulWidget {
  const Empresas({super.key});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  List<Empresa> _loadedItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    _loadedItems = [];
    final url = Uri.http(ip, 'empresas');
    final response = await http.get(url);
    List<dynamic> listData = json.decode(response.body);
    for (final item in listData) {
      Map<String, dynamic> rest = item;
      _loadedItems.add(
        Empresa(
          id: rest['idEmpresa'],
          cnpj: rest['cnpj'],
          inscricaoEstadual: rest['inscricaoEstadual'],
          nomeFantasia: rest['nomeFantasia'],
          razaoSocial: rest['razaoSocial'],
          inscricaoMunicipal: rest['inscricaoMunicipal'],
          email: rest['email'],
          foneEmpresa: rest['foneEmpresa'],
          nomeResponsavel: rest['nomeResponsavel'],
          foneResponsavel: rest['foneResponsavel'],
          emailResponsavel: rest['emailResponsavel'],
        ),
      );
    }
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Empresa>(
      MaterialPageRoute(
        builder: (context) => const NewEmpresa(),
      ),
    );
    if (newItem != null) {
      setState(() {
        _loadedItems.add(newItem);
      });
    }
  }

  void _editItem(Empresa empresa) async {
    final updatedItem = await Navigator.of(context).push<Empresa>(
      MaterialPageRoute(
        builder: (context) => EditEmpresa(empresa: empresa),
      ),
    );
    if (updatedItem != null) {
      final index =
          _loadedItems.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        setState(() {
          _loadedItems[index] = updatedItem;
        });
      }
    }
  }

  void _removeItem(Empresa empresa) {
    setState(() {
      _loadedItems.removeWhere((item) => item.id == empresa.id);
    });
    // Implement HTTP DELETE request here
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Empresa não cadastrada!'),
    );

    if (_loadedItems.isNotEmpty) {
      mainContent = EmpresasList(
        empresaList: _loadedItems,
        onRemoveEmpresa: _removeItem,
        onEditEmpresa: _editItem,
      );
    }

    List<String> menuItems = [];

    menuItems.add(Paginas.Funcionarios.toString());
    menuItems.add(Paginas.Passageiros.toString());
    menuItems.add(Paginas.Frota.toString());

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
