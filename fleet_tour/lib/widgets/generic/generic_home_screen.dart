import 'dart:convert';

import 'package:fleet_tour/configs/power_bi.dart';
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/widgets/generic/generic_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Veiculo> veiculos = [];

  void _loadVeiculos() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
    );
    var storage = GetStorage();
    final token = storage.read("token");
    final response = await http.get(Uri.http(ip, 'veiculos'),
        headers: {'authorization': "Bearer ${token!}"});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = await json.decode(response.body);
      for (var item in body) {
        veiculos.add(Veiculo.fromJson(item));
      }
    }
    Get.close(1);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVeiculos();
    });
  }

  Map<String, bool> status = {};

  Map<String, bool> _getVeiculosStatus() {
    for (Veiculo veiculo in veiculos) {
      if (veiculo.seguro != null && veiculo.seguro!.isBefore(DateTime.now())) {
        status[veiculo.placa!] = true;
      } else if (veiculo.ultimaVistoria != null &&
          veiculo.ultimaVistoria!.isBefore(DateTime.now())) {
        status[veiculo.placa!] = true;
      } else if (veiculo.licenciamentoAntt != null &&
          veiculo.licenciamentoAntt!.isBefore(DateTime.now())) {
        status[veiculo.placa!] = true;
      } else if (veiculo.licenciamentoDer != null &&
          veiculo.licenciamentoDer!.isBefore(DateTime.now())) {
        status[veiculo.placa!] = true;
      } else {
        status[veiculo.placa!] = false;
      }
    }

    return status;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      status = _getVeiculosStatus();
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Fleet Tour'),
        ),
        body: Column(
          children: [
            const Expanded(
              child: Center(
                child: LinkButton(url: 'https://app.powerbi.com/view?r=eyJrIjoiNzk0OTVjYzUtYzk4Zi00ODhmLTgzZDEtN2RhZGVjMDcwZDRiIiwidCI6Ijc5ZTEzMDcyLTA3YzMtNDlmYi04M2QyLTg0YmQ1MjgyNzUyYSJ9&pageName=ReportSection')
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: LucroDespesaPieChart(),
            ),
            if (status.containsValue(true))
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Card(
                  color: Colors.red[100], // Um tom suave de vermelho
                  child: ListTile(
                    leading: const Icon(Icons.warning,
                        color: Colors.red), // Ícone de alerta
                    title: const Text('Veículo apresenta pendências'),
                    subtitle: Text(
                        'Veículo: ${status.keys.firstWhere((key) => status[key] == true)}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Get.offAllNamed('/veiculos');
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/viagens');
                },
                child: const Text('Viagens'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/funcionarios');
                    },
                    child: const Text('Funcionários'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/contratantes');
                    },
                    child: const Text('Contratantes'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/passageiros');
                    },
                    child: const Text('Pssageiros'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/veiculos');
                    },
                    child: const Text('Veículos'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50)
          ],
        ));
  }
}
