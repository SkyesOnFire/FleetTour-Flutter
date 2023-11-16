import 'package:fleet_tour/models/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VeiculoTile extends StatelessWidget {
  const VeiculoTile(
    this.veiculo, {
    super.key,
    required this.onListAbastecimentos,
    required this.onListManutencoes,
    required this.onCreateAbastecimento,
    required this.onCreateManutencao, 
    required this.saveVeiculoForManutencao,
  });

  final Veiculo veiculo;
  final void Function(Veiculo veiculo) onListAbastecimentos;
  final void Function(Veiculo veiculo) onListManutencoes;
  final void Function() onCreateAbastecimento;
  final void Function() onCreateManutencao;
  final void Function(Veiculo veiculo) saveVeiculoForManutencao;

  void _escolherAbastecimento() {
    Get.dialog(
      AlertDialog(
        title: const Text('Abastecimentos'),
        content: const Text('Qual ação deseja realizar para este veículo?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Get.back();
              saveVeiculoForManutencao(veiculo);
              onCreateAbastecimento();
            },
            child: const Text('Cadastrar abastecimento', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Listar abastecimentos', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _escolherManutencao() {
    Get.dialog(
      AlertDialog(
        title: const Text('Manutenções'),
        content: const Text('Qual ação deseja realizar para este veículo?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Get.back();
              saveVeiculoForManutencao(veiculo);
              onCreateManutencao();
            },
            child: const Text('Cadastrar manutenção', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Listar manutenções', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.directions_bus),
      title: Text(
        veiculo.placa!,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: const Color.fromARGB(255, 39, 142, 178),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(context, Icons.remember_me_rounded,
                  "Renavam: ${veiculo.renavam}"),
              _buildRow(context, Icons.chair_rounded,
                  "${veiculo.capacidade.toString()} lugares"),
              _buildRow(
                  context, Icons.calendar_month_rounded, "Ano: ${veiculo.ano}"),
              _buildRow(context, Icons.roundabout_left_outlined,
                  "${veiculo.quilometragem} km"),
              _buildRow(context, Icons.edit_document, "TAF ${veiculo.taf}"),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => {_escolherAbastecimento()},
                      child: const Row(children: [
                        Icon(Icons.local_gas_station_rounded),
                        SizedBox(width: 4),
                        Text("Abastecimentos"),
                      ])),
                  ElevatedButton(
                      onPressed: () => {_escolherManutencao()},
                      child: const Row(children: [
                        Icon(Icons.build_rounded),
                        SizedBox(width: 4),
                        Text("Manutencões"),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 4),
        Expanded(child: Text(text)),
      ],
    );
  }
}
