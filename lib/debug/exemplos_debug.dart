import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExemplosDebug {

List<String> tipos = ["Entrada", "Saida", "Entrada", "Saida", "Entrada", "Saida", "Entrada", "Saida", "Entrada", "Saida", "Entrada", "Saida"];
List<double> valores = [1000, 200, 800, 300, 650, 900, 400, 700, 800, 350, 355, 450];
List<String> datas = ["2024-12-08T18:30:00", "2024-12-08T18:30:00", "2025-01-08T18:30:00", "2025-01-08T18:30:00", "2025-02-08T18:30:00", "2025-02-08T18:30:00", "2025-03-08T18:30:00", "2025-03-08T18:30:00", "2025-04-08T18:30:00", "2025-04-08T18:30:00", "2025-05-08T18:30:00", "2025-05-08T18:30:00"];
List<int> entradas = [1,0,1,0,1,0,1,0,1,0,1,0];
List<int> icones = [Icons.attach_money.codePoint, Icons.savings.codePoint, Icons.attach_money.codePoint, Icons.savings.codePoint, Icons.attach_money.codePoint, Icons.savings.codePoint, Icons.attach_money.codePoint, Icons.savings.codePoint, Icons.attach_money.codePoint, Icons.savings.codePoint, Icons.attach_money.codePoint, Icons.savings.codePoint,];
List<String> descricoes = ["debug", "debug", "debug", "debug", "debug", "debug", "debug", "debug", "debug", "debug", "debug", "debug", ];

void salvarDebug() {
  for(int i = 0; i < 12; i++){
    
    final Gastos dados = Gastos(
      tipoDoGasto: tipos[i],
      valor: valores[i],
      data: datas[i],
      entrada: entradas[i],
      iconCode: icones[i],
      descricao: descricoes[i],
    );

    DatabaseHelper.addGastos(dados);
  }
}

void apagarBancoDeDados() async {
  final caminhoDB = await getDatabasesPath();
  final caminhoCompleto = join(caminhoDB, 'Gastos.db'); // troque pelo nome do seu banco

  await deleteDatabase(caminhoCompleto);
  print('Banco de dados apagado com sucesso.');
}

}
