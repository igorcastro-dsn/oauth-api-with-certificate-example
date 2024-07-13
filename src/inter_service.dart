import 'dart:convert';
import 'package:http/http.dart' as http;
import 'inter_http_client.dart';

class InterService {

  final InterHttpClient httpClient;

  InterService(this.httpClient);

  Future<http.Response> obterBoletos() async {
    final url = Uri.parse('https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos');
    return await httpClient.get(url);
  }

  // Outros métodos para consumir API do banco inter
  
}
