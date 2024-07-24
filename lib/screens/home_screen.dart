import 'package:flutter/material.dart';
import '../services/cep_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cepController = TextEditingController();
  String _result = '';

  void _consultarCEP() async {
    String cep = _cepController.text;
    if (cep.isNotEmpty) {
      String result = await CepService.consultarCEP(cep);
      setState(() {
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta CEP ViaCEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o CEP',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _consultarCEP,
              child: Text('Consultar CEP'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}