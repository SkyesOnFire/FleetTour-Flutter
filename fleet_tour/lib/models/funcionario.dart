class Funcionario {
  final int id;
  final String funcao;
  final String nome;
  final String cpf;
  final String telefone;
  final String genero;
  final String rg;
  final String cnh;
  final DateTime dataNasc;
  final DateTime? vencimentoCnh;
  final DateTime? vencimentoCartSaude;

  Funcionario({
    required this.id,
    required this.funcao,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.genero,
    required this.rg,
    required this.cnh,
    required this.dataNasc,
    this.vencimentoCnh,
    this.vencimentoCartSaude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'funcao': funcao,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'genero': genero,
      'rg': rg,
      'cnh': cnh,
      'dataNasc': dataNasc.toIso8601String(),
      'vencimentoCnh': vencimentoCnh?.toIso8601String(),
      'vencimentoCartSaude': vencimentoCartSaude?.toIso8601String(),
    };
  }

  Funcionario.fromJson(Map<String, dynamic> json)
      : id = json['idFuncionario'],
        funcao = json['funcao'],
        nome = json['nome'],
        cpf = json['cpf'],
        telefone = json['telefone'],
        genero = json['genero'],
        rg = json['rg'],
        cnh = json['cnh'],
        dataNasc = DateTime.parse(json['dataNasc']),
        vencimentoCnh = json['vencimentoCnh'] != null ? DateTime.parse(json['vencimentoCnh']) : null,
        vencimentoCartSaude = json['vencimentoCartSaude'] != null ? DateTime.parse(json['vencimentoCartSaude']) : null;
}
