import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:fleet_tour/models/viagem.dart';

class Passageiro {
  int? idPassageiro;
  String? cpf;
  String? rg;
  String? nome;
  String? orgaoEmissor;
  String? telefone;
  String? email;
  String? tipoCliente;
  String? nomeFantasia;
  String? cnpj;
  DateTime? dataNasc;
  Empresa? empresa;
  Endereco? endereco;
  Endereco? enderecoLoja;
  List<Viagem>? viagens;

  Passageiro({
    this.idPassageiro,
    this.cpf,
    this.rg,
    this.nome,
    this.orgaoEmissor,
    this.telefone,
    this.email,
    this.tipoCliente,
    this.nomeFantasia,
    this.cnpj,
    this.dataNasc,
    this.empresa,
    this.endereco,
    this.enderecoLoja,
    this.viagens,
  });

  factory Passageiro.fromJson(Map<String, dynamic> json) {
    return Passageiro(
      idPassageiro: json['idPassageiro'],
      cpf: json['cpf'],
      rg: json['rg'],
      nome: json['nome'],
      orgaoEmissor: json['orgaoEmissor'],
      telefone: json['telefone'],
      email: json['email'],
      tipoCliente: json['tipoCliente'],
      nomeFantasia: json['nomeFantasia'],
      cnpj: json['cnpj'],
      dataNasc: json['dataNasc'] != null ? DateTime.parse(json['dataNasc']) : null,
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
      endereco: json['endereco'] != null ? Endereco.fromJson(json['endereco']) : null,
      enderecoLoja: json['enderecoLoja'] != null ? Endereco.fromJson(json['enderecoLoja']) : null,
      viagens: json['viagens'] != null ? List<Viagem>.from(json['viagens'].map((x) => Viagem.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPassageiro': idPassageiro,
      'cpf': cpf,
      'rg': rg,
      'nome': nome,
      'orgaoEmissor': orgaoEmissor,
      'telefone': telefone,
      'email': email,
      'tipoCliente': tipoCliente,
      'nomeFantasia': nomeFantasia,
      'cnpj': cnpj,
      'dataNasc': dataNasc?.toIso8601String(),
      'empresa': empresa?.toJson(),
      'endereco': endereco?.toJson(),
      'enderecoLoja': enderecoLoja?.toJson(),
      'viagens': viagens?.map((x) => x.toJson()).toList(),
    };
  }
}
