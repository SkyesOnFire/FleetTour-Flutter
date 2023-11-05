import 'package:flutter/material.dart';
import 'package:fleet_tour/models/funcionario.dart'; // Update with your model

class FuncionarioItem extends StatelessWidget {
  final Funcionario funcionario;

  FuncionarioItem({required this.funcionario});

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.work),
                  const SizedBox(width: 4),
                  Text(funcionario.funcao.toString())
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.numbers),
              const SizedBox(width: 4),
              Text(funcionario.telefone!),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.man),
                  const SizedBox(width: 4),
                  Text(funcionario.genero!)
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.edit_document),
              Text(" ${funcionario.cpf} "),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.insert_drive_file),
                  const SizedBox(width: 4),
                  Text("${funcionario.idFuncionario} ")
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
