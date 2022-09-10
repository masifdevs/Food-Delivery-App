class Bill_pay {
  String price;
  String balance;
  Bill_pay({this.price, this.balance});
  factory Bill_pay.fromJson(Map<String, dynamic> jsonData) {
    return Bill_pay(
      price: jsonData['b_amount'] as String,
      balance: jsonData['b_balance'] as String,
    );
  }
}
