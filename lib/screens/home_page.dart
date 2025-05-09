import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> _expandidos = {};
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Controle de Gasto'),
              accountEmail: Text(""),
            ),
            ListTile(
              title: Text("Historico"),
              subtitle: Text("Mostra o historico de Gastos dos Meses"),
              onTap: () => {print("Historico")},
              leading: Icon(Icons.history),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Controle de Gastos"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //body
        child: FutureBuilder<List<Gastos>?>(
          future: DatabaseHelper.getAllGastos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum gasto/entrada encontrado.'));
            }

            final gastos = snapshot.data!;

            return ListView.builder(
              itemBuilder: (context, index) {
                final expandido = _expandidos[index] ?? false;
                final gasto = gastos[index];

                return Column(
                  children: [
                    //ListTile
                    ListTile(
                      minTileHeight: 70,
                      leading: Icon(Icons.money, size: 45),
                      title: Text(gasto.tipoDoGasto, style: TextStyle(fontSize: 20)),
                      // ignore: unrelated_type_equality_checks
                      trailing: Text('R\$ ${gasto.valor.toStringAsFixed(2)}',style: TextStyle(fontSize: 20, color: gasto.entrada == 1 ? Colors.green : Colors.red),
                      ),
                      onTap: () {
                        setState(() {
                          _expandidos[index] = !expandido;
                        });
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Editar'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // ação de editar
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Excluir'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // ação de excluir
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                    AnimatedCrossFade(
                      firstChild: Container(),
                      secondChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text(gasto.descricao == null ? gasto.descricao! : "Sem Descrição"),
                          ],
                        ),
                      ),
                      crossFadeState:
                          expandido
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

      //Butões
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.of(context).pushNamed('/add')},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                //TODO Grafico de Gastos
              },
              child: Text('BOTÃO'),
            ),
            Text(
              'Total: R\$250',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
