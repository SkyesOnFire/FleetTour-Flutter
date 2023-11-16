import 'package:flutter/material.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/data/validation_utils.dart';

class PassageiroTile extends StatelessWidget {
  const PassageiroTile({super.key, required this.passageiro, this.isSelected = false});

  final Passageiro passageiro;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    String formattedDate = passageiro.dataNasc.toString();
    formattedDate = formattedDate.split("-").reversed.join("/");
    formattedDate = formattedDate.replaceAll(" 00:00:00.000Z", "");

    return ExpansionTile(
      
      leading: Icon(passageiro.tipoCliente == 'Turismo' 
      ? Icons.wallet_travel_rounded
      : Icons.shopping_cart_rounded), // Altere para um ícone apropriado
      title: Text(
        passageiro.nome!,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: isSelected ? Colors.green : const Color.fromARGB(255, 39, 142, 178),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildRow(context, Icons.remember_me_rounded, passageiro.rg.toString())),
                  Expanded(child: _buildRow(context, Icons.person_rounded, passageiro.cpf!)),
                ],
              ),
              _buildRow(context, Icons.edit_document, passageiro.orgaoEmissor.toString()),
              _buildRow(context, Icons.merge_type, passageiro.tipoCliente.toString()),
              _buildRow(context, Icons.phone_rounded, passageiro.telefone.toString()),
              _buildRow(context, Icons.cake_rounded, formattedDate),
              _buildRow(context, Icons.email_rounded, passageiro.email.toString()),
              if (passageiro.endereco != null)
                _buildRow(
                  context,
                  Icons.pin_drop_rounded,
                  '${passageiro.endereco?.rua}, ${passageiro.endereco?.numero} - ${passageiro.endereco?.cidade} / ${passageiro.endereco?.estado}'
                ),
              // Adicionar mais linhas conforme necessário
              // ...
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 4),
        Expanded(child: Text(text)),
      ],
    );
  }
}
