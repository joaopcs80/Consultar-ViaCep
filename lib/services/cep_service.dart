import 'package:dio/dio.dart';

class CepService {
  final Dio _dio = Dio();
  final String _viaCepUrl = 'https://viacep.com.br/ws';

  Future<Map<String, dynamic>?> getCepData(String cep) async {
    try {
      final formattedCep = cep.replaceAll(RegExp(r'\D'), '');

      if (formattedCep.length != 8) {
        throw Exception('CEP inválido. O CEP deve ter 8 dígitos.');
      }

      final response = await _dio.get('$_viaCepUrl/$formattedCep/json/');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Falha ao buscar dados do ViaCEP. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar dados do ViaCEP: $e');
    }
  }
}