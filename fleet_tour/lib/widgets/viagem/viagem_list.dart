import 'package:fleet_tour/widgets/viagem/viagem_card.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/viagem.dart';

class ViagemList extends StatelessWidget {
  const ViagemList(
      {super.key,
      required this.viagemList,
      required this.onRemoveViagem,
      required this.onEditViagem});

  final void Function(Viagem viagem) onEditViagem;
  final void Function(Viagem viagem) onRemoveViagem;
  final List<Viagem> viagemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viagemList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditViagem(viagemList[index]);
        },
        child: Dismissible(
            key: ValueKey(viagemList[index].idViagem),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onDismissed: (direction) {
              onRemoveViagem(viagemList[index]);
            },
            child: ViagemCard(viagemList[index])),
      ),
    );
  }
}
