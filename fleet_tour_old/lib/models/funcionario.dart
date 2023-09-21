// ignore_for_file: public_member_api_docs, sort_constructors_first

class Funcionario {
  final int id;
  final String nome;
  final String funcao;
  final String cpf;
  final String telefone;
  final String genero;
  final String rg;
  final String dataNasc;

  Funcionario({
    required this.id,
    required this.nome,
    required this.funcao,
    required this.cpf,
    required this.telefone,
    required this.genero,
    required this.rg,
    required this.dataNasc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'funcao': funcao,
      'cpf': cpf,
      'telefone': telefone,
      'genero': genero,
      'rg': rg,
      'dataNasc': dataNasc,
    };
  }
}
