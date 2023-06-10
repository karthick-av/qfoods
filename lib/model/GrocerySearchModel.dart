import 'package:qfoods/model/GroeryVariantItemModel.dart';

class GrocerySearchModel {
  int? groceryId;
  String? name;
  String? description;
  int? price;
  int? regularPrice;
  int? salePrice;
  String? combo;
  String? comboDescription;
  String? weight;
  String? image;
  String? offers;
  String? variant;
  List<Variants>? variants;

  GrocerySearchModel(
      {this.groceryId,
      this.name,
      this.description,
      this.price,
      this.regularPrice,
      this.salePrice,
      this.combo,
      this.comboDescription,
      this.weight,
      this.image,
      this.offers,
      this.variant,
      this.variants});

  GrocerySearchModel.fromJson(Map<String, dynamic> json) {
    groceryId = json['grocery_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    combo = json['combo'];
    comboDescription = json['combo_description'];
    weight = json['weight'];
    image = json['image'];
    offers = json['offers'];
    variant = json['variant'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grocery_id'] = this.groceryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['combo'] = this.combo;
    data['combo_description'] = this.comboDescription;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['offers'] = this.offers;
    data['variant'] = this.variant;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  int? id;
  String? name;
  List<GroeryVariantItemModel>? items;

  Variants({this.id, this.name, this.items});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['items'] != null) {
      items = <GroeryVariantItemModel>[];
      json['items'].forEach((v) {
        items!.add(new GroeryVariantItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
