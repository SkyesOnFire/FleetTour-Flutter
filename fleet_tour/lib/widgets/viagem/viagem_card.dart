import 'package:flutter/material.dart';
import 'package:fleet_tour/models/viagem.dart';
import 'package:get/get.dart';

class ViagemCard extends StatelessWidget {
  const ViagemCard(this.viagem, {super.key});

  final Viagem viagem;

  @override
  Widget build(BuildContext context) {
    String formattedDate = viagem.dataViagem.toString();
    formattedDate = formattedDate.split("-").reversed.join("/");
    formattedDate = formattedDate.replaceAll(" 00:00:00.000Z", "");

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    viagem.destino!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Spacer(),
                Text(
                  viagem.veiculo!.placa!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(viagem.contratante!.tipoPessoa == 'Jurídica'
                    ? Icons.business
                    : Icons.person_rounded),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                      viagem.contratante!.tipoPessoa == 'Jurídica'
                          ? viagem.contratante!.nomeFantasia!
                          : viagem.contratante!.nome!,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.assignment_ind_rounded),
                const SizedBox(width: 4),
                Text(viagem.passageiros!.length == 1 
                ? '${viagem.passageiros!.length.toString()} passageiro'
                : '${viagem.passageiros!.length.toString()} passageiros'),
                const Spacer(),
                const Icon(Icons.edit_document),
                const SizedBox(width: 4),
                Text(
                    'NFe: ${viagem.nfe!}',
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.money_rounded),
                const SizedBox(width: 4),
                Text('R\$ ${viagem.valorNfe!.toStringAsFixed(0)} | R\$ ${viagem.valor!.toStringAsFixed(0)} NFe'),
                const Spacer(),
                const Icon(Icons.merge_type_rounded),
                const SizedBox(width: 4),
                Text(viagem.status!),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.add_road_rounded),
                const SizedBox(width: 4),
                Text('${viagem.km!.toStringAsFixed(0)} km'),
                const Spacer(),
                const Icon(Icons.calendar_month_rounded),
                const SizedBox(width: 4),
                Text(formattedDate),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  if (viagem.funcionarios != null && viagem.funcionarios!.isNotEmpty)
                    const Icon(Icons.person_4_rounded),
                  if (viagem.funcionarios != null && viagem.funcionarios!.isNotEmpty)
                    const SizedBox(width: 4),
                  if (viagem.funcionarios != null && viagem.funcionarios!.isNotEmpty)
                    Expanded(child: Text(viagem.funcionarios![0].nome!)),
                  if (viagem.funcionarios!.length > 1)
                    Expanded(child: Text(' | ${viagem.funcionarios![1].nome!}')),
                  if (viagem.funcionarios!.length > 2)
                    Expanded(child: Text(' | ${viagem.funcionarios![3].nome!}')),
              ],
            ),
            if (viagem.observacao != null)
              Row(
                children: [
                  const Icon(Icons.library_books_rounded),
                  const SizedBox(width: 4),
                  Expanded(child: Text(viagem.observacao!)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
