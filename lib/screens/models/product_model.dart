// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Product> welcomeFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String welcomeToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int id;
  String title;
  double price;
  String description;
  Category category;
  String image;
  Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: CategoryExtension.fromString(json["category"]) ??
            Category.ELECTRONICS,
        image: json["image"],
        rating: Rating.fromJson(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category.name,
        "image": image,
        "rating": rating.toJson(),
      };
}

enum Category { ELECTRONICS, JEWELERY, MEN_S_CLOTHING, WOMEN_S_CLOTHING }

/*final categoryValues = EnumValues({
  "electronics": Category.ELECTRONICS,
  "jewelery": Category.JEWELERY,
  "men's clothing": Category.MEN_S_CLOTHING,
  "women's clothing": Category.WOMEN_S_CLOTHING
});*/
/*extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.ELECTRONICS:
        return 'Electronics';
      case Category.JEWELERY:
        return 'Jewelry';
      case Category.MEN_S_CLOTHING:
        return 'Men Clothing';
      case Category.WOMEN_S_CLOTHING:
        return 'Women Clothing';
      default:
        return '';
    }
  }
  
}*/
extension CategoryExtension on Category {
  static Category fromString(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Category.ELECTRONICS;
      case 'jewelery':
        return Category.JEWELERY;
      case 'men clothing':
        return Category.MEN_S_CLOTHING;
      case 'women clothing':
        return Category.WOMEN_S_CLOTHING;
      default:
        return Category.ELECTRONICS; // Default to ELECTRONICS if not recognized
    }
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
