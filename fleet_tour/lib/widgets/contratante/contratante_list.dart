import 'package:fleet_tour/widgets/contratante/contratante_card.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/contratante.dart';

class ContratanteList extends StatelessWidget {
  const ContratanteList(
      {super.key,
      required this.contratanteList,
      required this.onRemoveContratante,
      required this.onEditContratante});

  final void Function(Contratante contratante) onEditContratante;
  final void Function(Contratante contratante) onRemoveContratante;
  final List<Contratante> contratanteList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contratanteList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditContratante(contratanteList[index]);
        },
        child: Dismissible(
            key: ValueKey(contratanteList[index].idContratante),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onDismissed: (direction) {
              onRemoveContratante(contratanteList[index]);
            },
            child: ContratanteCard(contratante: contratanteList[index])),
      ),
    );
  }
}
