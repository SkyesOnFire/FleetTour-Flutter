class Empresa {
  final int id;
  final String cnpj;
  final String nomeFantasia;
  final String razaoSocial;
  final String? inscricaoMunicipal;
  final String? inscricaoEstadual;
  final String email;
  final String? foneEmpresa;
  final String nomeResponsavel;
  final String foneResponsavel;
  final String emailResponsavel;

  Empresa({
    required this.id,
    required this.cnpj,
    required this.nomeFantasia,
    required this.razaoSocial,
    this.inscricaoMunicipal,
    this.inscricaoEstadual,
    required this.email,
    this.foneEmpresa,
    required this.nomeResponsavel,
    required this.foneResponsavel,
    required this.emailResponsavel
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEmpresa': id,
      'cnpj': cnpj,
      'nomeFantasia': nomeFantasia,
      'razaoSocial': razaoSocial,
      'inscricaoMunicipal': inscricaoMunicipal,
      'inscricaoEstadual': inscricaoEstadual,
      'email': email,
      'foneEmpresa': foneEmpresa,
      'nomeResponsavel': nomeResponsavel,
      'foneResponsavel': foneResponsavel,
      'emailResponsavel': emailResponsavel
    };
  }
}
