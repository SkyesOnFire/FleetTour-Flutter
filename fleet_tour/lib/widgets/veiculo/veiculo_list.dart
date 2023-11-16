import 'package:fleet_tour/widgets/veiculo/veiculo_card.dart';
import 'package:fleet_tour/widgets/veiculo/veiculo_tile.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/veiculo.dart';

class VeiculoList extends StatelessWidget {
  const VeiculoList(
      {super.key,
      required this.veiculoList,
      required this.onRemoveVeiculo,
      required this.onEditVeiculo, 
      required this.onListAbastecimentos,
      required this.onListManutencoes,
      required this.onCreateAbastecimento,
      required this.onCreateManutencao, 
      required this.saveVeiculoForManutencao});

  final void Function(Veiculo veiculo) saveVeiculoForManutencao;
  final void Function(Veiculo veiculo) onEditVeiculo;
  final void Function(Veiculo veiculo) onRemoveVeiculo;
  final void Function(Veiculo veiculo) onListAbastecimentos;
  final void Function(Veiculo veiculo) onListManutencoes;
  final void Function() onCreateAbastecimento;
  final void Function() onCreateManutencao;
  final List<Veiculo> veiculoList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: veiculoList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditVeiculo(veiculoList[index]);
        },
        child: Dismissible(
            key: ValueKey(veiculoList[index].idVeiculo),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onDismissed: (direction) {
              onRemoveVeiculo(veiculoList[index]);
            },
            child: VeiculoTile(
              veiculoList[index],
            onListAbastecimentos: onListAbastecimentos,
            onListManutencoes: onListManutencoes,
            onCreateAbastecimento: onCreateAbastecimento,
            onCreateManutencao: onCreateManutencao,
            saveVeiculoForManutencao: saveVeiculoForManutencao,
            )),
      ),
    );
  }
}
