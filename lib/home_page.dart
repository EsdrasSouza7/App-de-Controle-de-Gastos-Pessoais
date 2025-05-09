import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> _expandidos = {};

  @override
  Widget build(BuildContext context) {
    final itens = ['Produto A', 'Produto B', 'Produto C'];

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
              onTap: () => {print("Historioco")},
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
        child: ListView.builder(
          itemCount: itens.length,
          itemBuilder: (context, index) {
            final item = itens[index];
            final expandido = _expandidos[index] ?? false;
        
            return Column(
              children: [
                //ListTile
                ListTile(
                  minTileHeight: 70,
                  leading: Icon(Icons.money, size: 45),
                  title: Text(item, style: TextStyle(fontSize: 20)),
                  trailing: Text(
                    "Valor",
                    style: TextStyle(fontSize: 20, color: Colors.green),
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
                        Text('Descrição detalhada de $item'),
                        SizedBox(height: 8),
                        Text('Preço: R\$ ${(index + 1) * 10},00'),
                        SizedBox(height: 8),
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
        ),
      ),

      //Butões
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
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
                // ação de finalizar compra
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
