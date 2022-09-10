class Customer {
  String customer_id;
  String orderno;
  String address;
  String username;
  double lng;
  double lat;
  String phone_nmbr;

  Customer({
    this.customer_id,
    this.orderno,
    this.address,
    this.username,
    this.phone_nmbr,
    this.lng,
    this.lat,
  });
  factory Customer.fromJson(Map<String, dynamic> jsonData) {
    return Customer(
      customer_id: jsonData['id'],
      orderno: jsonData['o_id'],
      address: jsonData['address'],
      username: jsonData['Name'],
      phone_nmbr: jsonData['phone'],
      lat: double.parse(jsonData['lat']),
      lng: double.parse(jsonData['lng']),
    );
  }
}
