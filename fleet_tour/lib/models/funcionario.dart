import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:fleet_tour/models/manutencao.dart';
import 'package:fleet_tour/models/viagem.dart';

class Funcionario {
  int? idFuncionario;
  String? funcao;
  String? nome;
  String? cpf;
  String? telefone;
  String? genero;
  String? rg;
  String? cnh;
  DateTime? dataNasc;
  DateTime? vencimentoCnh;
  DateTime? vencimentoCartSaude;
  Empresa? empresa;
  Endereco? endereco;
  List<Manutencao>? manutencoes;
  List<Viagem>? viagens;

  Funcionario({
    this.idFuncionario,
    this.funcao,
    this.nome,
    this.cpf,
    this.telefone,
    this.genero,
    this.rg,
    this.cnh,
    this.dataNasc,
    this.vencimentoCnh,
    this.vencimentoCartSaude,
    this.empresa,
    this.endereco,
    this.manutencoes,
    this.viagens,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      idFuncionario: json['idFuncionario'],
      funcao: json['funcao'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      genero: json['genero'],
      rg: json['rg'],
      cnh: json['cnh'],
      dataNasc: json['dataNasc'] != null ? DateTime.parse(json['dataNasc']) : null,
      vencimentoCnh: json['vencimentoCnh'] != null ? DateTime.parse(json['vencimentoCnh']) : null,
      vencimentoCartSaude: json['vencimentoCartSaude'] != null ? DateTime.parse(json['vencimentoCartSaude']) : null,
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
      endereco: json['endereco'] != null ? Endereco.fromJson(json['endereco']) : null,
      manutencoes: json['manutencoes'] != null ? List<Manutencao>.from(json['manutencoes'].map((x) => Manutencao.fromJson(x))) : null,
      viagens: json['viagens'] != null ? List<Viagem>.from(json['viagens'].map((x) => Viagem.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idFuncionario': idFuncionario,
      'funcao': funcao,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'genero': genero,
      'rg': rg,
      'cnh': cnh,
      'dataNasc': dataNasc?.toIso8601String(),
      'vencimentoCnh': vencimentoCnh?.toIso8601String(),
      'vencimentoCartSaude': vencimentoCartSaude?.toIso8601String(),
      'empresa': empresa?.toJson(),
      'endereco': endereco?.toJson(),
      'manutencoes': manutencoes?.map((x) => x.toJson()).toList(),
      'viagens': viagens?.map((x) => x.toJson()).toList(),
    };
  }
}
