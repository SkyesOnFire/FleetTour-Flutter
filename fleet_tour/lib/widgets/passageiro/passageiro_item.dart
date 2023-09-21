import 'package:flutter/material.dart';
import 'package:fleet_tour/models/passageiro.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.passageiro, {super.key});

  final Passageiro passageiro;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              passageiro.nome,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.merge_type),
                const SizedBox(width: 4),
                Text(passageiro.tipoCliente.toString()),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.dock_outlined),
                    const SizedBox(width: 4),
                    Text(passageiro.orgaoEmissor.toString()),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.document_scanner),
                const SizedBox(width: 4),
                Text(passageiro.rg.toString()),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
