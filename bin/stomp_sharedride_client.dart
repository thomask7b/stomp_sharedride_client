import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:stomp_sharedride_client/auth_service.dart';
import 'package:stomp_sharedride_client/gpx_service.dart';
import 'package:stomp_sharedride_client/location.dart';
import 'package:stomp_sharedride_client/stomp_service.dart';
import 'package:stomp_sharedride_client/user.dart';

enum MODE { send, receive }

Future<void> main(List<String> arguments) async {
  final ArgParser parser = ArgParser()
    ..addOption("user",
        abbr: "u", mandatory: true, help: "Le nom d'utilisateur")
    ..addOption("password",
        abbr: "p", mandatory: true, help: "Le mot de passe utilisateur")
    ..addOption("sharedride-id",
        abbr: "s", mandatory: true, help: "L'ID du shared ride")
    ..addOption("gpx", abbr: "g", help: "Le fichier GPX")
    ..addOption("interval",
        abbr: "i",
        defaultsTo: "1",
        help: "Intervale d'émission en secondes (accepte les décimales)");

  final ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } on Exception catch (e) {
    print(e.toString());
    print(parser.usage);
    exit(1);
  }

  final user = argResults["user"];
  final password = argResults["password"];
  final sharedRideId = argResults["sharedride-id"];
  final mode = argResults["gpx"] == null ? MODE.receive : MODE.send;

  if (!await authenticate(User(user, password))) {
    stderr.writeln("Impossible de s'authentifier");
    exit(1);
  }

  if (mode == MODE.receive) {
    print("Démarrage du client en mode récéption.");
    startStompClient();
  } else {
    final gpxFile = File(argResults["gpx"]);
    final interval = double.parse(argResults["interval"]);
    print("Démarrage du client en mode émission.");
    startStompClient(
        onConnect: (frame) => startSendingLocations(
            trkPtsStream(gpxFile, interval), sharedRideId));
  }
}

Future<void> startSendingLocations(
    Stream<Location> locationsStream, String sharedRideId) async {
  await for (final value in locationsStream) {
    print("Envoi de : ${value.longitude} ${value.latitude}");
    sendStompLocation(jsonEncode(<String, dynamic>{
      'sharedRideId': sharedRideId,
      'username': authenticatedUser!.name,
      'location': value
    }));
  }
}
