import 'package:flutter/material.dart';
import 'package:fleet_tour/models/onibus.dart';

import 'onibus_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key,
      required this.onibusList,
      required this.onRemoveExpense,
      required this.onEditExpense});

  final void Function(Onibus onibus) onRemoveExpense;
  final void Function(Onibus onibus) onEditExpense;
  final List<Onibus> onibusList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: onibusList.length,
        itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                onEditExpense(onibusList[index]);
              },
              child: Dismissible(
                  key: ValueKey(onibusList[index]),
                  background: Container(
                    color:
                        Theme.of(context).colorScheme.error.withOpacity(0.75),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  onDismissed: (direction) {
                    onRemoveExpense(onibusList[index]);
                  },
                  child: ExpenseItem(onibusList[index])),
            ));
  }
}
