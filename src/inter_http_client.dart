import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class InterHttpClient {
  
  static const String _crtFile = 'path/to/your/certificate.crt'; // colocar arquivo dentro do projeto e referenciar o caminho aqui
  static const String _keyFile = 'path/to/your/private.key'; // colocar arquivo dentro do projeto e referenciar o caminho aqui
  static const String _passphrase = 'your_passphrase'; // trocar pela senha (se houver)
  static const String _clientId = 'your_client_id'; // trocar pelo client_id
  static const String _clientSecret = 'your_client_secret'; // trocar pela secret
  static const String _tokenUrl = 'https://cdpj.partners.bancointer.com.br/oauth/v2/token';

  http.Client? _client;
  String? _accessToken;

  Future<http.Client> _createClient() async {
    if (_client == null) {
      final securityContext = SecurityContext(withTrustedRoots: false);
      securityContext.useCertificateChain(_crtFile);
      securityContext.usePrivateKey(_keyFile, password: _passphrase);

      final httpClient = HttpClient(context: securityContext);
      _client = IOClient(httpClient);
    }
    return _client!;
  }

  Future<void> authenticate() async {
    final client = await _createClient();

    final response = await client.post(
      Uri.parse(_tokenUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': _clientId,
        'client_secret': _clientSecret,
        'grant_type': 'client_credentials',
        'scope': 'extrato.read boleto-cobranca.read boleto-cobranca.write',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _accessToken = jsonResponse['access_token'];
      print('Access Token: $_accessToken');
    } else {
      throw Exception('Failed to obtain access token: ${response.reasonPhrase}');
    }
  }

  Future<http.Response> get(Uri url) async {
    await authenticate();
    final client = await _createClient();
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    return response;
  }

}
