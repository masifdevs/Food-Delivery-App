
class Product {
  final int id;
  final String title;
  final String categoryid;
  final String imgUrl;
  double price;
  int qty;
  int totalqty;

  Product(
      {this.id,
      this.title,
      this.categoryid,
      this.price,
      this.imgUrl,
      this.qty = 1,
      this.totalqty});
  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
      id: int.parse(jsonData['prod_id']),
      title: jsonData['prod_name'],
      price: double.parse(jsonData['prod_price']),
      totalqty: int.parse(jsonData['Total_Qty']),
      imgUrl: jsonData['prod_image'],
    );
  }
}
