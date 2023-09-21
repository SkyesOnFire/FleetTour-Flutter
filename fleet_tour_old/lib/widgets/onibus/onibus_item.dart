import 'package:flutter/material.dart';
import 'package:fleet_tour/models/onibus.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.onibus, {super.key});

  final Onibus onibus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            onibus.placa,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("Renavam: ${onibus.renavam}"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.chair_rounded),
                  const SizedBox(width: 4),
                  Text(onibus.capacidade.toString())
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.bus_alert_sharp),
              const SizedBox(width: 4),
              Text(onibus.numeroFrota),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded),
                  const SizedBox(width: 4),
                  Text(onibus.ano)
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.roundabout_left_outlined),
              Text(" ${onibus.km} km"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.edit_document),
                  const SizedBox(width: 4),
                  Text("${onibus.taf} TAF")
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
