import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'auth_service.dart';

late final StompClient _stompClient;

void startStompClient({Function(StompFrame)? onConnect}) {
  print("Connexion...");
  _stompClient = StompClient(
      config: StompConfig(
    url: 'ws://localhost:8080/sharedride-ws-endpoint',
    webSocketConnectHeaders: {
      'Cookie': sessionId!,
    },
    onWebSocketError: (error) => print(error.toString()),
    onConnect: (frame) {
      print("Connecté!");
      if (onConnect == null) {
        _stompClient.subscribe(
          destination: '/user/sharedride-ws/locations',
          callback: (frame) {
            print("Localisation reçue :");
            print(jsonDecode(frame.body!));
          },
        );
      } else {
        onConnect(frame);
      }
    },
  ));
  _stompClient.activate();
}

void sendStompLocation(String body) {
  _stompClient.send(destination: '/app/location', body: body);
  print('Localisation envoyée!');
}
