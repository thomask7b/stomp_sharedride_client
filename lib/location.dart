class Location {
  final double latitude;
  final double longitude;

  const Location(
    this.latitude,
    this.longitude,
  );

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
