import 'package:fleet_tour/models/endereco.dart';

class Empresa {
  int? id;
  String? cnpj;
  String? nomeFantasia;
  String? razaoSocial;
  String? inscricaoMunicipal;
  String? inscricaoEstadual;
  String? email;
  String? foneEmpresa;
  String? nomeResponsavel;
  String? foneResponsavel;
  String? emailResponsavel;
  Endereco? endereco;

  Empresa({
    this.id,
    this.cnpj,
    this.nomeFantasia,
    this.razaoSocial,
    this.inscricaoMunicipal,
    this.inscricaoEstadual,
    this.email,
    this.foneEmpresa,
    this.nomeResponsavel,
    this.foneResponsavel,
    this.emailResponsavel, 
    this.endereco,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      cnpj: json['cnpj'],
      nomeFantasia: json['nomeFantasia'],
      razaoSocial: json['razaoSocial'],
      inscricaoMunicipal: json['inscricaoMunicipal'],
      inscricaoEstadual: json['inscricaoEstadual'],
      email: json['email'],
      foneEmpresa: json['foneEmpresa'],
      nomeResponsavel: json['nomeResponsavel'],
      foneResponsavel: json['foneResponsavel'],
      emailResponsavel: json['emailResponsavel'],
      endereco: Endereco.fromJson(json['endereco']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnpj': cnpj,
      'nomeFantasia': nomeFantasia,
      'razaoSocial': razaoSocial,
      'inscricaoMunicipal': inscricaoMunicipal,
      'inscricaoEstadual': inscricaoEstadual,
      'email': email,
      'foneEmpresa': foneEmpresa,
      'nomeResponsavel': nomeResponsavel,
      'foneResponsavel': foneResponsavel,
      'emailResponsavel': emailResponsavel,
      'endereco': endereco?.toJson(),
    };
  }
}
