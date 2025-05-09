import 'package:flutter/material.dart';

class Gastos {
  final int? id;
  final String tipoDoGasto;
  final double valor;
  final String? descricao;
  final int iconCode;
  final int entrada;

  const Gastos({
    required this.tipoDoGasto,
    required this.valor,
    this.descricao,
    required this.entrada,
    required this.iconCode,
    this.id,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  factory Gastos.fromJson(Map<String, dynamic> json) => Gastos(
    id: json['id'],
    tipoDoGasto: json['tipoDoGasto'],
    valor: json['valor'],
    iconCode: json['iconCode'],
    descricao: json['descricao'],
    entrada: json['entrada']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipoDoGasto': tipoDoGasto,
    'valor': valor,
    'iconCode': iconCode,
    'descricao': descricao,
    'entrada': entrada
  };
}
