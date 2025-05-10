import 'package:flutter/material.dart';

class Gastos {
  final int? id;
  final String tipoDoGasto;
  final String data;
  final double valor;
  final String? descricao;
  final int iconCode;
  final int entrada;

  const Gastos({
    this.id,
    required this.tipoDoGasto,
    required this.data,
    required this.valor,
    this.descricao,
    required this.iconCode,
    required this.entrada,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  factory Gastos.fromJson(Map<String, dynamic> json) => Gastos(
    id: json['id'],
    tipoDoGasto: json['tipoDoGasto'],
    data: json['data'],
    valor: json['valor'],
    iconCode: json['iconCode'],
    descricao: json['descricao'],
    entrada: json['entrada']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipoDoGasto': tipoDoGasto,
    'data': data,
    'valor': valor,
    'iconCode': iconCode,
    'descricao': descricao,
    'entrada': entrada
  };
}
