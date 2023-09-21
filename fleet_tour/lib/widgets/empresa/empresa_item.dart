import 'package:flutter/material.dart';
import 'package:fleet_tour/models/empresa.dart';

class EmpresaItem extends StatelessWidget {
  final Empresa empresa;

  const EmpresaItem(this.empresa, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            empresa.nomeFantasia,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("CNPJ: ${empresa.cnpj}"),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 4),
                  Text(empresa.email.toString())
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.numbers),
              const SizedBox(width: 4),
              Text(empresa.foneResponsavel),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.business),
                  const SizedBox(width: 4),
                  Text(empresa.nomeResponsavel)
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.email),
              Text(" ${empresa.emailResponsavel} "),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.edit_document),
                  const SizedBox(width: 4),
                  Text("${empresa.id} ")
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
