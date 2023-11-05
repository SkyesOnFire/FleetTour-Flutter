import 'package:flutter/material.dart';
import 'package:fleet_tour/models/passageiro.dart';

import 'passageiro_item.dart';

class PassageirosList extends StatelessWidget {
  const PassageirosList({
    Key? key,
    required this.passageiroList,
    required this.onRemoveExpense,
    required this.onEditExpense,
  }) : super(key: key);

  final List<Passageiro> passageiroList;
  final void Function(Passageiro passageiro) onRemoveExpense;
  final void Function(Passageiro passageiro) onEditExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: passageiroList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditExpense(passageiroList[index]);
        },
        child: Dismissible(
          key: ValueKey(passageiroList[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onDismissed: (direction) {
            onRemoveExpense(passageiroList[index]);
          },
          child: PassageiroItem(passageiroList[index]),
        ),
      ),
    );
  }
}
