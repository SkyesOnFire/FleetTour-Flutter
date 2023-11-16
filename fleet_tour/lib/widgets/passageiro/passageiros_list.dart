import 'package:fleet_tour/widgets/passageiro/passageiro_tile.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/passageiro.dart';

import 'passageiro_card.dart';

class PassageirosList extends StatelessWidget {
  const PassageirosList({
    Key? key,
    required this.passageiroList,
    required this.onRemovePassageiro,
    required this.onEditPassageiro,
  }) : super(key: key);

  final List<Passageiro> passageiroList;
  final void Function(Passageiro passageiro) onRemovePassageiro;
  final void Function(Passageiro passageiro) onEditPassageiro;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: passageiroList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditPassageiro(passageiroList[index]);
        },
        child: Dismissible(
          key: ValueKey(passageiroList[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onDismissed: (direction) {
            onRemovePassageiro(passageiroList[index]);
          },
          child: PassageiroTile(passageiro: passageiroList[index]),
        ),
      ),
    );
  }
}
