import 'package:fleet_tour/data/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:fleet_tour/models/passageiro.dart';

class PassageiroCard extends StatelessWidget {
  const PassageiroCard({super.key, required this.passageiro, this.isSelected = false,});

  final Passageiro passageiro;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    String formattedDate = passageiro.dataNasc.toString();
    formattedDate = formattedDate.split("-").reversed.join("/");
    formattedDate = formattedDate.replaceAll(" 00:00:00.000Z", "");

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
                    passageiro.nome!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.remember_me_rounded),
                const SizedBox(width: 4),
                Text(passageiro.rg.toString()),
                const Spacer(),
                const Icon(Icons.person_rounded),
                const SizedBox(width: 4),
                Text(passageiro.cpf!),
                const Spacer(),
                const Icon(Icons.edit_document),
                const SizedBox(width: 4),
                Text(passageiro.orgaoEmissor.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.merge_type),
                const SizedBox(width: 4),
                Text(passageiro.tipoCliente.toString()),
                const Spacer(),
                const Icon(Icons.phone_rounded),
                const SizedBox(width: 4),
                Text(passageiro.telefone.toString()),
                const Spacer(),
                const Icon(Icons.cake_rounded),
                const SizedBox(width: 4),
                Text(formattedDate),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email_rounded),
                const SizedBox(width: 4),
                Text(passageiro.email.toString()),
              ],
            ),
            if (passageiro.endereco != null) const SizedBox(height: 4),
            if (passageiro.endereco != null)
              Row(
                children: [
                  const Icon(Icons.pin_drop_rounded),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                        '${passageiro.endereco?.rua}, ${passageiro.endereco?.numero} - ${passageiro.endereco?.cidade} / ${passageiro.endereco?.estado}'),
                  ),
                ],
              ),
              
            if (passageiro.tipoCliente == 'Compras')
            const Divider(),
            if (passageiro.tipoCliente == 'Compras')
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded),
                  const SizedBox(width: 4),
                  Text(formatCNPJ(passageiro.cnpj!)),
                ],
              ),
            if (passageiro.tipoCliente == 'Compras')
              Row(
                children: [
                  const Icon(Icons.shop_two_rounded),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('${passageiro.nomeFantasia}'),
                  ),
                ],
              ),
            if (passageiro.tipoCliente == 'Compras')
              Row(
                children: [
                  const Icon(Icons.store_rounded),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                        '${passageiro.enderecoLoja?.rua}, ${passageiro.enderecoLoja?.numero} - ${passageiro.enderecoLoja?.cidade} / ${passageiro.enderecoLoja?.estado}'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
