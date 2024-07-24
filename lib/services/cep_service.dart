import 'package:http/http.dart' as http;
import 'dart:convert';

class CepService {
  static Future<String> consultarCEP(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.containsKey('erro')) {
          return 'CEP não encontrado';
        } else {
          return '''
          Logradouro: ${data['logradouro']}
          Bairro: ${data['bairro']}
          Cidade: ${data['localidade']}
          Estado: ${data['uf']}
          ''';
        }
      } else {
        return 'Falha na requisição: ${response.statusCode}';
      }
    } catch (error) {
      return 'Erro: $error';
    }
  }
}