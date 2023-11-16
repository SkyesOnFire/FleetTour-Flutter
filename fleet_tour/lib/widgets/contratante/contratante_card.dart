import 'package:flutter/material.dart';
import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/data/validation_utils.dart';

class ContratanteCard extends StatelessWidget {
  const ContratanteCard({super.key, required this.contratante, this.isSelected = false,});

  final Contratante contratante;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.green : const Color.fromARGB(255, 39, 142, 178),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    contratante.tipoPessoa == 'Física'
                        ? contratante.nome!
                        : contratante.nomeFantasia!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            if (contratante.tipoPessoa == 'Jurídica')
              const SizedBox(height: 4),
            if (contratante.tipoPessoa == 'Jurídica')
              Row(
              children: [
                const Icon(Icons.business),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(contratante.razaoSocial!,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(contratante.tipoPessoa == 'Física'
                ? Icons.person_rounded
                : Icons.assignment_ind_rounded),
                const SizedBox(width: 4),
                Text(contratante.tipoPessoa == 'Física'
                    ? contratante.cpf!
                    : formatCNPJ(contratante.cnpj!)),
                const Spacer(),
                if (contratante.tipoPessoa == 'Jurídica')
                  const Icon(Icons.map_outlined),
                  if (contratante.tipoPessoa == 'Jurídica')
                  const SizedBox(width: 4),
                if (contratante.tipoPessoa == 'Jurídica')
                  Expanded(
                    child: Text(
                      'IE: ${contratante.inscricaoEstadual!}',
                    ),
                  ),
              ],
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.merge_type),
                  const SizedBox(width: 4),
                  Text(contratante.tipoPessoa.toString()),
                  const Spacer(),
                  const Icon(Icons.phone_rounded),
                  const SizedBox(width: 4),
                  Text(contratante.telefone.toString()),
                ],
              ),
            Row(
              children: [
                const Icon(Icons.email_rounded),
                const SizedBox(width: 4),
                Text(contratante.email.toString()),
              ],
            ),
            if (contratante.endereco != null) const SizedBox(height: 4),
            if (contratante.endereco != null)
              Row(
                children: [
                  const Icon(Icons.pin_drop_rounded),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                        '${contratante.endereco?.rua}, ${contratante.endereco?.numero} - ${contratante.endereco?.cidade} / ${contratante.endereco?.estado}'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
