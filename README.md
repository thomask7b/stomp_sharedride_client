### Description :

Simule un utilisateur se déplaçant sur un shared ride lorsqu'un fichier gpx est fournit en paramètre :

```
dart stomp_sharedride_client.dart --gpx /home/user/Dole_Salin-les-Bains.gpx -i 0.5 -u test3 -p zeze -s 634294fec405402d3cb33598
```

Sinon écoute les nouvelles localisations pour un shared ride :

```
dart stomp_sharedride_client.dart -u test4 -p zeze -s 634294fec405402d3cb33598
```

### Usage :

```
-u, --user (mandatory)             Le nom d'utilisateur
-p, --password (mandatory)         Le mot de passe utilisateur
-s, --sharedride-id (mandatory)    L'ID du shared ride
-g, --gpx                          Le fichier GPX
-i, --interval                     Intervale d'émission en secondes (accepte les décimales)
                                   (defaults to "1")
```

Exemples de fichiers GPX : https://github.com/gps-touring/sample-gpx