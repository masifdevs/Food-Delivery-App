import 'package:practiceapp/Constants.dart';

class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> jsondata) {
    return Category(
      id: int.parse(jsondata['cat_id']),
      name: jsondata['cat_name'],
      imageUrl: Category_Image_Api_Address + jsondata['cat_img_name'],
    );
  }
}
