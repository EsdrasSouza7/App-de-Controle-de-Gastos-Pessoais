import 'package:controle_de_gasto/app_controler.dart';
import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:controle_de_gasto/screens/add_gasto_page.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> _expandidos = {};
  final DatabaseHelper dbHelper = DatabaseHelper();
  DateTime dataAtual = DateTime.now();
  late dynamic mes;

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
              onTap:
                  () => {
                    Navigator.pushNamed(context, '/historico')
                  },
              leading: Icon(Icons.history),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Controle de Gastos"),
        actions: [CustomSwitch()],
        
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //body
        child: FutureBuilder<List<Gastos>?>(
          future: DatabaseHelper.getGastosDoMes(dataAtual.year, dataAtual.month),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum gasto/entrada encontrado.'));
            }

            final gastos = snapshot.data!;

            return ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final expandido = _expandidos[index] ?? false;
                final gasto = gastos[index];
                DateTime data = DateTime.parse(
                  gasto.data,
                ); 

                String dataFormatada = DateFormat(
                  'dd/MM/yyyy',
                ).format(data); // Ex: 08/05/2025
                String horaFormatada = DateFormat('HH:mm').format(data);

                return Column(
                  children: [
                    //ListTile
                    ListTile(
                      minTileHeight: 70,
                      leading: Icon(gasto.icon, size: 45),
                      title: Text(
                        gasto.tipoDoGasto,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        'R\$ ${gasto.valor.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          color: gasto.entrada == 1 ? Colors.green : Colors.red,
                        ),
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
                                      editarGasto(context, gasto);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Excluir'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      deletarGasto(context, gasto);
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
                            Text(
                              gasto.descricao != ""
                                  ? gasto.descricao!
                                  : "Sem Descrição",
                            ),
                            SizedBox(height: 25),
                            Text('Data: $dataFormatada - Hora: $horaFormatada'),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 105,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Colors.red,
                                          ),
                                    ),
                                    onPressed: () {
                                      deletarGasto(context, gasto);
                                    },
                                    child: Text(
                                      "Deletar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                SizedBox(
                                  height: 35,
                                  width: 105,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                            Colors.blue,
                                          ),
                                    ),
                                    onPressed: () {
                                      editarGasto(context, gasto); 
                                    },
                                    child: Text(
                                      "Editar",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddGastoPage(), // passando o gasto
            ),
          ).then((_) => setState(() {})); // recarrega após voltar
        },
        child: Icon(Icons.add, color: Colors.black,),
      ),
      //Valores Embaixo
      bottomNavigationBar: FutureBuilder(
        future: DatabaseHelper.getGastosDoMes(dataAtual.year, dataAtual.month),
        builder: (context, snapshot) {
          double entradas = 0;
          double saidas = 0;
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //Se não tiver Nada no Banco
            return BottomNavigationBar(
              unselectedLabelStyle: TextStyle(fontSize: 20),
              selectedLabelStyle: TextStyle(fontSize: 20),
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_downward, color: Colors.green),
                  label: "R\$ ${entradas.toStringAsFixed(2)}",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_upward, color: Colors.red),
                  label: "R\$ ${saidas.toStringAsFixed(2)}",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet, color: Colors.blue),
                  label: "R\$ 0.00 ",
                ),
              ],
              currentIndex: 2,
              onTap: (index) {},
            );
          }
          //
          //Banco de Dados Não Nulo
          //
          final gastos = snapshot.data!;
          for (int i = 0; i < gastos.length; i++) {
            if (gastos[i].entrada == 1) {
              entradas += gastos[i].valor;
            } else {
              saidas += gastos[i].valor;
            }
          }

          final saldo = entradas - saidas;

          return BottomNavigationBar(
            unselectedLabelStyle: TextStyle(fontSize: 20),
            selectedLabelStyle: TextStyle(fontSize: 20),
            selectedItemColor: saldo > 0 ? Colors.green : Colors.red,
            unselectedItemColor: AppControler.instance.isdartTheme ? const Color.fromARGB(255, 235, 235, 235) : Colors.black,
            backgroundColor: AppControler.instance.isdartTheme ? Colors.black : const Color.fromARGB(255, 235, 235, 235),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward, color: Colors.green),
                label: "R\$ ${entradas.toStringAsFixed(2)}",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward, color: Colors.red),
                label: "R\$ ${saidas.toStringAsFixed(2)}",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet, color: Colors.blue),
                label: "R\$ ${saldo.toStringAsFixed(2)}",
              ),
            ],
            currentIndex: 2,
            onTap: (index) {
              //TODO Graficos de Saidas e Entrads ps:Quando Tiver adicionado datas e troca do mês
            },
          );
        },
      ),
    );
  }

  void deletarGasto(BuildContext context, Gastos gasto) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Quer realmente Exluir essa Transação?"),
        actions: [
          ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.red)), onPressed: () {DatabaseHelper.deleteGastos(gasto); Navigator.pop(context); setState(() {});}, child: Text("Sim")), 
          ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue)), onPressed: (){Navigator.pop(context);}, child: Text("Não"))
        ],
      );
    });
  }

  void editarGasto(BuildContext context, Gastos gasto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddGastoPage(gasto: gasto,), // passando o gasto
      ), ).then((_) => setState(() {}),); // recarrega após voltar
  }
}
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.dark_mode),
        Switch(
          value: AppControler.instance.isdartTheme,
          onChanged: (value) {
            AppControler.instance.changeTheme();
          },
        ),
      ],
    );
  }
}
