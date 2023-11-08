import 'package:flutter/material.dart';
import 'package:fleet_tour/models/funcionario.dart'; // Update with your model

class FuncionarioCard extends StatelessWidget {
  final Funcionario funcionario;

  const FuncionarioCard({super.key, required this.funcionario});

  @override
  Widget build(BuildContext context) {
    String formattedDate = funcionario.dataNasc.toString();
    formattedDate = formattedDate.split("-").reversed.join("/");
    formattedDate = formattedDate.replaceAll(" 00:00:00.000Z", "");
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            funcionario.nome!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("CNH: ${funcionario.cnh}"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.work_rounded),
                  const SizedBox(width: 4),
                  Text(funcionario.funcao.toString())
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.phone_rounded),
              const SizedBox(width: 4),
              Text(funcionario.telefone!),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.man_rounded),
                  const SizedBox(width: 4),
                  Text(funcionario.genero!)
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.edit_document),
              Text(funcionario.cpf!),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded),
                  const SizedBox(width: 4),
                  Text(formattedDate)
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
