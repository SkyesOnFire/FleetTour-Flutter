import 'package:flutter/material.dart';
import 'package:fleet_tour/models/veiculo.dart';

class VeiculoCard extends StatelessWidget {
  const VeiculoCard(this.veiculo, {super.key});

  final Veiculo veiculo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            veiculo.placa!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("Renavam: ${veiculo.renavam}"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.chair_rounded),
                  const SizedBox(width: 4),
                  Text(veiculo.capacidade.toString())
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.bus_alert_sharp),
              const SizedBox(width: 4),
              Text(veiculo.codFrota!),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded),
                  const SizedBox(width: 4),
                  Text(veiculo.ano!)
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.roundabout_left_outlined),
              Text(" ${veiculo.quilometragem} km"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.edit_document),
                  const SizedBox(width: 4),
                  Text("${veiculo.taf} TAF")
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
