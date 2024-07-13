import 'package:flutter/material.dart';
import 'inter_service.dart';
import 'inter_http_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    
  final InterHttpClient httpClientWithCert = InterHttpClient();
  final InterService interService = InterService(InterHttpClient());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('OAuth2 Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final response = await interService.obterBoletos();
                print(response.body);
              } catch (e) {
                print('Error: $e');
              }
            },
            child: Text('Obter Boletos'),
          ),
        ),
      ),
    );
  }
}
