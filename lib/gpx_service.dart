import 'dart:async';
import 'dart:io';

import 'package:gpx/gpx.dart';
import 'package:stomp_sharedride_client/location.dart';

final _gpxReader = GpxReader();

Stream<Location> trkPtsStream(File gpxFile, double interval) async* {
  final gpx = _gpxReader.fromString(gpxFile.readAsStringSync());
  final trkPts = gpx.trks.first.trksegs.first.trkpts;
  for (var point in trkPts) {
    sleep(Duration(milliseconds: (interval * 1000).round()));
    yield Location(point.lat!, point.lon!);
  }
}

