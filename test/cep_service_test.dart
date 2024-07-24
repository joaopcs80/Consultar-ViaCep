import 'package:flutter_test/flutter_test.dart';
import 'package:consultarviacep/services/cep_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CepService', () {
    test('retorna informações de endereço para um CEP válido', () async {
      final client = MockClient((request) async {
        return http.Response(
          '{"logradouro": "Avenida Paulista", "bairro": "Bela Vista", "localidade": "São Paulo", "uf": "SP"}',
          200,
        );
      });

      CepService.client = client; 
      final result = await CepService.consultarCEP('01311000');
      expect(result, contains('Avenida Paulista'));
      expect(result, contains('Bela Vista'));
      expect(result, contains('São Paulo'));
      expect(result, contains('SP'));
    });

    test('retorna mensagem de erro para um CEP inválido', () async {
      final client = MockClient((request) async {
        return http.Response('{"erro": true}', 200);
      });

      CepService.client = client; 
      final result = await CepService.consultarCEP('00000000');
      expect(result, 'CEP não encontrado');
    });

    test('retorna mensagem de erro para falha na requisição', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      CepService.client = client;
      final result = await CepService.consultarCEP('01311000');
      expect(result, 'Falha na requisição: 404');
    });
  });
}