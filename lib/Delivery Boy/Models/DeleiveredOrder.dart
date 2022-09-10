class DeliveredOrder {
  String customer_name;
  String order_no;
  String supplied_time;
  String supplied_date;
  String delivered_address;
  DeliveredOrder(
      {this.customer_name,
      this.order_no,
      this.supplied_date,
      this.supplied_time,
      this.delivered_address});
  factory DeliveredOrder.fromJson(Map<String, dynamic> jsonData) {
    return DeliveredOrder(
      customer_name: jsonData['Name'],
      order_no: jsonData['o_id'] as String,
      supplied_date: jsonData['sp_date'] as String,
      supplied_time: jsonData['sp_time'] as String,
      delivered_address: jsonData['address'] as String,
    );
  }
}
