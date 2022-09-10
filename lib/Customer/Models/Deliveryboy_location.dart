class DeliverBoy {
  String address;
  String username;
  double lng;
  double lat;
  

  DeliverBoy({
    this.address,
    this.username,
    this.lng,
    this.lat,
  });
  factory DeliverBoy.fromJson(Map<String, dynamic> jsonData) {
    return DeliverBoy(
      address: jsonData['address'],
      username: jsonData['name'],
      lat: double.parse(jsonData['lat']),
      lng: double.parse(jsonData['lng']),
    );
  }
}
