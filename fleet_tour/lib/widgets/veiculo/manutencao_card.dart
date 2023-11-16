import 'package:flutter/material.dart';
import 'package:fleet_tour/models/manutencao.dart';
import 'package:intl/intl.dart'; // Para formatar datas

class ManutencaoCard extends StatelessWidget {
  const ManutencaoCard(this.manutencao, {super.key});

  final Manutencao manutencao;

  @override
  Widget build(BuildContext context) {
    // Formatar a data da manutenção
    String formattedDate = manutencao.dataManutencao != null
        ? DateFormat('dd/MM/yyyy').format(manutencao.dataManutencao!)
        : 'Data não informada';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Manutenção ${manutencao.idManutencao ?? ''}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 4),
              Text(formattedDate),
              const Spacer(),
              if (manutencao.valor != null)
                Row(
                  children: [
                    const Icon(Icons.attach_money),
                    const SizedBox(width: 4),
                    Text("R\$ ${manutencao.valor!.toStringAsFixed(2)}")
                  ],
                ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.speed),
              const SizedBox(width: 4),
              Text("${manutencao.km ?? ''} km"),
              const Spacer(),
              if (manutencao.nomeOficina != null)
                Row(
                  children: [
                    const Icon(Icons.store),
                    const SizedBox(width: 4),
                    Text(manutencao.nomeOficina!)
                  ],
                ),
            ],
          ),
          if (manutencao.observacao != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.notes),
                const SizedBox(width: 4),
                Expanded(child: Text(manutencao.observacao!)),
              ],
            ),
          ],
        ]),
      ),
    );
  }
}
