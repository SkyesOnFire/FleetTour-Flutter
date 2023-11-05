import 'package:fleet_tour/models/empresa.dart';

class Usuario {
  int? idUsuario;
  String? login;
  String? senha;
  String? nivelAcesso;
  bool? ativo;
  DateTime? dataNascimento;
  String? nome;
  String? cpf;
  String? telefone;
  String? genero;
  Empresa? empresa;

  Usuario({
    this.idUsuario,
    this.login,
    this.senha,
    this.nivelAcesso,
    this.ativo,
    this.dataNascimento,
    this.nome,
    this.cpf,
    this.telefone,
    this.genero,
    this.empresa,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      login: json['login'],
      senha: json['senha'],
      nivelAcesso: json['nivelAcesso'],
      ativo: json['ativo'],
      dataNascimento: json['dataNascimento'] != null ? DateTime.parse(json['dataNascimento']) : null,
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      genero: json['genero'],
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'login': login,
      'senha': senha,
      'nivelAcesso': nivelAcesso,
      'ativo': ativo,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'genero': genero,
      'empresa': empresa?.toJson(),
    };
  }
}
