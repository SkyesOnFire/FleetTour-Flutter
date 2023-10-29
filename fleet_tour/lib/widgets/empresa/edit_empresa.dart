import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleet_tour/configs/server.dart';
import 'package:fleet_tour/models/empresa.dart';

class EditEmpresa extends StatefulWidget {
  final Empresa empresa;

  const EditEmpresa({Key? key, required this.empresa}) : super(key: key);

  @override
  State<EditEmpresa> createState() => _EditEmpresaState();
}

class _EditEmpresaState extends State<EditEmpresa> {
  final _formKey = GlobalKey<FormState>();
  late String _editedCnpj;
  late String _editedNomeFantasia;
  late String _editedRazaoSocial;
  late String _editedEmail;
  late String _editedNomeResponsavel;
  late String _editedFoneResponsavel;
  late String _editedEmailResponsavel;

  @override
  void initState() {
    super.initState();
    _editedCnpj = widget.empresa.cnpj;
    _editedNomeFantasia = widget.empresa.nomeFantasia;
    _editedRazaoSocial = widget.empresa.razaoSocial;
    _editedEmail = widget.empresa.email;
    _editedNomeResponsavel = widget.empresa.nomeResponsavel;
    _editedFoneResponsavel = widget.empresa.foneResponsavel;
    _editedEmailResponsavel = widget.empresa.emailResponsavel;
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedEmpresa = Empresa(
        id: widget.empresa.id,
        cnpj: _editedCnpj,
        nomeFantasia: _editedNomeFantasia,
        razaoSocial: _editedRazaoSocial,
        email: _editedEmail,
        nomeResponsavel: _editedNomeResponsavel,
        foneResponsavel: _editedFoneResponsavel,
        emailResponsavel: _editedEmailResponsavel,
      );

      final url = Uri.http(ip, 'empresas/${widget.empresa.id}');
      final body = json.encode(updatedEmpresa.toMap());
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.body);
      print(response.statusCode);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Empresa"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  25,
                  initialValue: _editedCnpj,
                  decoration: const InputDecoration(labelText: 'CNPJ'),
                  onSaved: (value) {
                    _editedCnpj = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedNomeFantasia,
                  decoration: const InputDecoration(labelText: 'Nome Fantasia'),
                  onSaved: (value) {
                    _editedNomeFantasia = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedRazaoSocial,
                  decoration: const InputDecoration(labelText: 'Razão Social'),
                  onSaved: (value) {
                    _editedRazaoSocial = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) {
                    _editedEmail = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedNomeResponsavel,
                  decoration:
                      const InputDecoration(labelText: 'Nome Responsável'),
                  onSaved: (value) {
                    _editedNomeResponsavel = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedFoneResponsavel,
                  decoration:
                      const InputDecoration(labelText: 'Telefone Responsável'),
                  onSaved: (value) {
                    _editedFoneResponsavel = value!;
                  },
                ),
                TextFormField(
                  255,
                  initialValue: _editedEmailResponsavel,
                  decoration:
                      const InputDecoration(labelText: 'Email Responsável'),
                  onSaved: (value) {
                    _editedEmailResponsavel = value!;
                  },
                ),
                // Implement your logic for editing logo here
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
