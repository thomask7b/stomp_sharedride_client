import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stomp_sharedride_client/user.dart';

String? _sessionId;
User? _authenticatedUser;

String? get sessionId => _sessionId;
User? get authenticatedUser => _authenticatedUser;

Future<bool> authenticate(User user) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/auth'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'name': user.name, 'password': user.password}),
  );
  print("Requête d'authentification envoyée.");
  if (response.statusCode == 200) {
    _sessionId = response.headers['set-cookie'];
    print("Authentification réussie.");
    _authenticatedUser = user;
    return true;
  }
  _sessionId = null;
  _authenticatedUser = null;
  return false;
}
