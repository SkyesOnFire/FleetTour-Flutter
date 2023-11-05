import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/endereco.dart';
import 'package:fleet_tour/models/viagem.dart';

class Contratante {
  int? idContratante;
  String? tipoPessoa;
  String? cnpj;
  String? cpf;
  String? nome;
  String? razaoSocial;
  String? nomeFantasia;
  String? inscricaoEstadual;
  String? telefone;
  String? celular;
  String? email;
  String? tipoCliente;
  Endereco? endereco;
  Empresa? empresa;
  List<Viagem>? viagens;

  Contratante({
    this.idContratante,
    this.tipoPessoa,
    this.cnpj,
    this.cpf,
    this.nome,
    this.razaoSocial,
    this.nomeFantasia,
    this.inscricaoEstadual,
    this.telefone,
    this.celular,
    this.email,
    this.tipoCliente,
    this.endereco,
    this.empresa,
    this.viagens,
  });

  factory Contratante.fromJson(Map<String, dynamic> json) {
    return Contratante(
      idContratante: json['idContratante'],
      tipoPessoa: json['tipoPessoa'],
      cnpj: json['cnpj'],
      cpf: json['cpf'],
      nome: json['nome'],
      razaoSocial: json['razaoSocial'],
      nomeFantasia: json['nomeFantasia'],
      inscricaoEstadual: json['inscricaoEstadual'],
      telefone: json['telefone'],
      celular: json['celular'],
      email: json['email'],
      tipoCliente: json['tipoCliente'],
      endereco: json['endereco'] != null ? Endereco.fromJson(json['endereco']) : null,
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
      viagens: json['viagens'] != null ? (json['viagens'] as List).map((i) => Viagem.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idContratante': idContratante,
      'tipoPessoa': tipoPessoa,
      'cnpj': cnpj,
      'cpf': cpf,
      'nome': nome,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'inscricaoEstadual': inscricaoEstadual,
      'telefone': telefone,
      'celular': celular,
      'email': email,
      'tipoCliente': tipoCliente,
      'endereco': endereco?.toJson(),
      'empresa': empresa?.toJson(),
      'viagens': viagens?.map((e) => e.toJson()).toList(),
    };
  }
}
