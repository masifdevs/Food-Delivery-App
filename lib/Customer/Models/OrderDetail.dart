class OrdersDetail {
  String name;
  String qty;
  String price;
  String date;
  OrdersDetail({this.name, this.qty, this.price, this.date});
  factory OrdersDetail.fromJson(Map<String, dynamic> jsonData) {
    return OrdersDetail(
      name: jsonData['io_name'],
      qty: jsonData['io_qty'] as String,
      price: jsonData['io_price'] as String,
      date: jsonData['o_date'] as String,
    );
  }
}
