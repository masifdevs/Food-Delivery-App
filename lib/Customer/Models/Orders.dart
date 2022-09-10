class OrderItem {
  String id;
  String date;
  String time;
  String bill;
  OrderItem({
    this.id,
    this.date,
    this.time,
    this.bill,
  });
  factory OrderItem.fromJson(Map<String, dynamic> jsonData) {
    return OrderItem(
      id: jsonData['o_id'],
      date: jsonData['o_date'] as String,
      time: jsonData['o_time'] as String,
      bill: jsonData['o_price'] as String,
    );
  }
}
