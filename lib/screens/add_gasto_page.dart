import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';

class AddGastoPage extends StatefulWidget {
  final Gastos? gasto;
  const AddGastoPage({
    super.key,
    this.gasto
  });

  @override
  State<AddGastoPage> createState() => _AddGastoPageState();
}

class _AddGastoPageState extends State<AddGastoPage> {
  late TextEditingController tipoController;
  late TextEditingController valorController;
  late TextEditingController descricaoController;
  final DatabaseHelper dbHelper = DatabaseHelper();
  bool isEntrada = true;
  DateTime data = DateTime.now();
  dynamic id;
  IconData? iconeSelecionado;
  bool podeSalvar = false;

@override
void initState() {
  super.initState();
  id = widget.gasto?.id;
  tipoController = TextEditingController(text: widget.gasto?.tipoDoGasto ?? '');
  descricaoController = TextEditingController(text: widget.gasto?.descricao ?? '');
  valorController = TextEditingController(text: widget.gasto?.valor.toString() ?? '');
  isEntrada = !(widget.gasto?.entrada == 0);
  data = widget.gasto != null ? DateTime.parse(widget.gasto!.data) : DateTime.now();
  tipoController.addListener(_validarCampos);
  valorController.addListener(_validarCampos);
}

  final List<IconData> icones = [
    Icons.shopping_cart,
    Icons.fastfood,
    Icons.home,
    Icons.directions_car,
    Icons.phone_android,
    Icons.school,
    Icons.attach_money,
    Icons.savings,
    Icons.card_giftcard,
    Icons.flight,
  ];

  void _validarCampos() {
    final tipo = tipoController.text.trim();
    final valor = double.tryParse(valorController.text.trim()) ?? 0.0;

    setState(() {
      podeSalvar = tipo.isNotEmpty && valor > 0 && iconeSelecionado != null;
    });
  }

  void _selecionarIcone(IconData icone) {
    setState(() {
      iconeSelecionado = icone;
      _validarCampos();
    });
  }

  void salvarTransacao() {
    final tipo = tipoController.text;
    final valor = double.tryParse(valorController.text) ?? 0.0;
    final descricao = descricaoController.text;
    final String dataStr = DateTime.now().toIso8601String(); // "2025-05-08T18:30:00"

    final Gastos dados = Gastos(
      id: id,
      tipoDoGasto: tipo,
      valor: valor,
      data: dataStr,
      entrada: isEntrada ? 1 : 0,
      iconCode: iconeSelecionado!.codePoint,
      descricao: descricao,
    );

    if (widget.gasto == null) {
      DatabaseHelper.addGastos(dados);
      ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transação salva com sucesso!')));
    } else {
       DatabaseHelper().updateGasto(dados);
       ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transação editada com sucesso!')));
    }

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    tipoController.dispose();
    valorController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  //BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Adicionar Gasto/Entrada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: tipoController,
              decoration: InputDecoration(
                labelText: 'Tipo do Gasto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: valorController,
              decoration: InputDecoration(
                labelText: 'Valor (ex: 50.00)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 15),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição (Opicional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            SwitchListTile(
              title: Text(isEntrada ? 'Tipo: Entrada' : 'Tipo: Gasto'),
              value: isEntrada,
              onChanged: (value) => setState(() => isEntrada = value),
              activeColor: Colors.yellow[700],
            ),
            SizedBox(height: 20),
            Text(
              'Selecione um ícone:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children:
                  icones.map((icone) {
                    final selecionado = iconeSelecionado == icone;
                    return GestureDetector(
                      onTap: () => _selecionarIcone(icone),
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              selecionado ? Colors.blue[100] : Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                selecionado ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(icone, size: 30, color: Colors.black87),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            FilledButton.icon(
              icon: Icon(Icons.save, color: Colors.black,),
              label: Text('Salvar Transação', style: TextStyle(color: Colors.black)),
              onPressed: podeSalvar ? salvarTransacao : null,
            ),
          ],
        ),
      ),
    );
  }
}
