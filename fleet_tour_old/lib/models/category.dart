// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum Paginas {
  Frota,
  Passageiros,
  Funcionarios
}

class Category {
  final String categoryName;
  final Color categoryColor;

  const Category(
    this.categoryName,
    this.categoryColor,
  );
}
