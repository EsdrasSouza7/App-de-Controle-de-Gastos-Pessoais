import 'package:controle_de_gasto/screens/historico_mes_page.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historico"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //TODO Modo Escuro
      ),
      body: SizedBox(
        child: FutureBuilder<List<String>>(
          future: DatabaseHelper().getMesesComGastos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            final meses = snapshot.data!;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: meses.length,
                itemBuilder: (context, index) {
                  final mes = meses[index];
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            formatarMes(mes),
                            style: TextStyle(fontSize: 22),
                          ),
                          subtitle:
                              isMesAtual(mes) ? Text("Mês Atual") : Text(''),
                          onTap: () {
                            if (isMesAtual(mes)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistoricoMesPage(mesAno: mes,),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String formatarMes(String mes) {
    final partes = mes.split('-');
    final ano = partes[0];
    final mesNumero = int.parse(partes[1]);

    const nomesMeses = [
      '',
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${nomesMeses[mesNumero]}/$ano';
  }

  bool isMesAtual(String anoMes) {
    final agora = DateTime.now();
    final anoMesAtual =
        '${agora.year.toString().padLeft(4, '0')}-${agora.month.toString().padLeft(2, '0')}';
    return anoMes == anoMesAtual;
  }
}
