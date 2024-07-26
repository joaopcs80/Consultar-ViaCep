import 'dart:convert';
import 'package:dio/dio.dart';

class CepRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://parseapi.back4app.com/classes/SuaClasse';
  final String _applicationId = 'SEU_APPICATION_ID';
  final String _clientKey = 'SEU_CLIENT_KEY';

  CepRepository() {
    _dio.options.headers = {
      'X-Parse-Application-Id': _applicationId,
      'X-Parse-REST-API-Key': _clientKey,
      'Content-Type': 'application/json',
    };
  }

  Future<void> createCep(Map<String, dynamic> cepData) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: jsonEncode(cepData),
      );
      if (response.statusCode != 201) {
        throw Exception('Falha ao criar CEP');
      }
    } catch (e) {
      throw Exception('Falha ao criar CEP: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllCeps() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Falha ao carregar CEPs');
      }
    } catch (e) {
      throw Exception('Falha ao carregar CEPs: $e');
    }
  }

  Future<void> updateCep(String objectId, Map<String, dynamic> cepData) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/$objectId',
        data: jsonEncode(cepData),
      );
      if (response.statusCode != 200) {
        throw Exception('Falha ao atualizar CEP');
      }
    } catch (e) {
      throw Exception('Falha ao atualizar CEP: $e');
    }
  }

  Future<void> deleteCep(String objectId) async {
    try {
      final response = await _dio.delete('$_baseUrl/$objectId');
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar CEP');
      }
    } catch (e) {
      throw Exception('Falha ao deletar CEP: $e');
    }
  }
}
