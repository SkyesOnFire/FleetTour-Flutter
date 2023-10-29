import 'endereco.dart';
import 'empresa.dart';
import 'viagem.dart';

class Contratante {
  int idContratante;
  String tipoPessoa;
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
  Empresa empresa;
  List<Viagem>? viagens;

  Contratante({
    required this.idContratante,
    required this.tipoPessoa,
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
    required this.empresa,
    this.viagens,
  });
}