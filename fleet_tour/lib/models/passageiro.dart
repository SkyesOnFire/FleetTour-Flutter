// ignore_for_file: public_member_api_docs, sort_constructors_first

class Passageiro {
  final int id;
  final String nome;
  final String rg;
  final String orgaoEmissor;
  final String tipoCliente;
  final DateTime? dataNasc;

  Passageiro({
    required this.id,
    required this.nome,
    required this.rg,
    required this.orgaoEmissor,
    required this.tipoCliente,
    this.dataNasc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'rg': rg,
      'orgaoEmissor': orgaoEmissor,
      'tipoCliente': tipoCliente,
      'dataNasc': dataNasc,
    };
  }
}
