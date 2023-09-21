class Empresa {
  final int id;
  final String cnpj;
  final String? inscricaoEstadual;
  final String nomeFantasia;
  final String razaoSocial;
  final String? inscricaoMunicipal;
  final String email;
  final String? foneEmpresa;
  final String nomeResponsavel;
  final String foneResponsavel;
  final String emailResponsavel;
  final List<int>? logo;  // byte array for logo

  Empresa({
    required this.id,
    required this.cnpj,
    this.inscricaoEstadual,
    required this.nomeFantasia,
    required this.razaoSocial,
    this.inscricaoMunicipal,
    required this.email,
    this.foneEmpresa,
    required this.nomeResponsavel,
    required this.foneResponsavel,
    required this.emailResponsavel,
    this.logo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEmpresa': id,
      'cnpj': cnpj,
      'inscricaoEstadual': inscricaoEstadual,
      'nomeFantasia': nomeFantasia,
      'razaoSocial': razaoSocial,
      'inscricaoMunicipal': inscricaoMunicipal,
      'email': email,
      'foneEmpresa': foneEmpresa,
      'nomeResponsavel': nomeResponsavel,
      'foneResponsavel': foneResponsavel,
      'emailResponsavel': emailResponsavel,
      'logo': logo,
    };
  }
}
