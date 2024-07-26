import 'package:flutter/material.dart';
import '../services/cep_service.dart';
import '../repository/cep_repository.dart';

class CepPage extends StatefulWidget {
  @override
  _CepPageState createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  final CepService _cepService = CepService();
  final CepRepository _cepRepository = CepRepository();
  List<Map<String, dynamic>> _ceps = [];
  final TextEditingController _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCeps();
  }

  Future<void> _loadCeps() async {
    try {
      final ceps = await _cepRepository.getAllCeps();
      setState(() {
        _ceps = ceps;
      });
    } catch (e) {
      _showErrorDialog('Erro ao carregar CEPS: $e');
    }
  }

  Future<void> _addCep(String cep) async {
    try {
      final cepData = await _cepService.getCepData(cep);
      if (cepData != null && cepData['cep'] != null) {
        await _cepRepository.createCep(cepData);
        _loadCeps();
      } else {
        _showErrorDialog('CEP não encontrado.');
      }
    } catch (e) {
      _showErrorDialog('Erro ao cadastrar CEP: $e');
    }
  }

  Future<void> _updateCep(String objectId, String cep) async {
    try {
      final cepData = await _cepService.getCepData(cep);
      if (cepData != null && cepData['cep'] != null) {
        await _cepRepository.updateCep(objectId, cepData);
        _loadCeps();
      } else {
        _showErrorDialog('CEP não encontrado.');
      }
    } catch (e) {
      _showErrorDialog('Erro ao atualizar CEP: $e');
    }
  }

  Future<void> _deleteCep(String objectId) async {
    try {
      await _cepRepository.deleteCep(objectId);
      _loadCeps();
    } catch (e) {
      _showErrorDialog('Erro ao excluir CEP: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCepDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar CEP'),
          content: TextField(
            controller: _cepController,
            decoration: InputDecoration(labelText: 'CEP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _addCep(_cepController.text);
                _cepController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCepDialog(String objectId, String currentCep) {
    _cepController.text = currentCep;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar CEP'),
          content: TextField(
            controller: _cepController,
            decoration: InputDecoration(labelText: 'CEP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _updateCep(objectId, _cepController.text);
                _cepController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEPs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCepDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _ceps.length,
        itemBuilder: (context, index) {
          final cep = _ceps[index];
          return ListTile(
            title: Text(cep['cep'] ?? 'Não disponível'),
            subtitle: Text('${cep['logradouro']}, ${cep['bairro']}, ${cep['cidade']}, ${cep['estado']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditCepDialog(cep['objectId'], cep['cep']),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCep(cep['objectId']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}