import 'dart:convert';

import 'package:fleet_tour/data/validation_utils.dart';
import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Empresas extends StatefulWidget {
  const Empresas({super.key});

  @override
  State<Empresas> createState() => _EmpresasState();
}

class _EmpresasState extends State<Empresas> {
  Empresa _empresa = Empresa();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItems();
    });
  }

  void _editCompany() {
    Get.toNamed('/empresas/editar', arguments: _empresa);
  }

  void _editAddress() async {
    await Get.toNamed('/endereco', arguments: _empresa.endereco);
    var storage = GetStorage();
    final endereco = storage.read('temp_endereco');

    if (endereco != null) {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 500),
      );

      _empresa.endereco = endereco;
      storage.remove('temp_endereco');
      final token = storage.read("token");
      final url = Uri.http(ip, 'empresas');
      final body = json.encode(_empresa.toJson());
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (!context.mounted) {
        return;
      }

      if (response.statusCode == 200) {
        Get.close(1);
        Get.snackbar(
          'Sucesso',
          'Endereço alterado com sucesso',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.close(1);
        Get.snackbar(
          'Erro ao salvar',
          'Por favor, tente novamente',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      setState(() {});
    }
  }

  void _loadItems() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
    );
    var storage = GetStorage();
    final token = storage.read("token");
    final url = Uri.http(ip, 'empresas');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    _empresa = Empresa.fromJson(
        json.decode(utf8.decode(response.body.runes.toList())));
    Get.close(1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('Empresa não cadastrada!'),
    );

    if (_empresa.cnpj != null) {
      mainContent = Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _empresa.nomeFantasia!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.business),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(_empresa.razaoSocial!,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.assignment_ind_rounded),
                const SizedBox(width: 4),
                Text(formatCNPJ(_empresa.cnpj!)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.email_rounded),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _empresa.email!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone_rounded),
                const SizedBox(width: 4),
                Text(formatTelefone(_empresa.foneEmpresa!)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.map_rounded),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Inscricão Municipal: ${_empresa.inscricaoMunicipal!}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.map_outlined),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Inscricão Estadual: ${_empresa.inscricaoEstadual!}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Endereço",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${_empresa.endereco!.rua!} ${_empresa.endereco!.numero!}, ${_empresa.endereco!.bairro!}, ${_empresa.endereco!.cidade!} - ${_empresa.endereco!.estado!} ${_empresa.endereco!.pais!}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.markunread_mailbox_rounded),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    formatCep(_empresa.endereco!.cep!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Dados do Responsável",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_rounded),
                const SizedBox(width: 4),
                Text(_empresa.nomeResponsavel!),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone_rounded),
                const SizedBox(width: 4),
                Text(formatTelefone(_empresa.foneResponsavel!)),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email_rounded),
                Text(" ${_empresa.emailResponsavel} "),
                const Spacer(),
              ],
            )
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownMenuButton(),
              ],
            ),
          ),
        ],
      ),
      body: _empresa.cnpj == null
          ? Column(
              children: [Expanded(child: mainContent)],
            )
          : Column(
              children: [
                mainContent,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _editAddress,
                      child: Text('Editar Endereço'),
                    ),
                    ElevatedButton(
                      onPressed: _editCompany,
                      child: const Text('Editar Empresa'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
