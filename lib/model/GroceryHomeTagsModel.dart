class GroceryHomeTagsModel {
  int? tagId;
  String? tagName;
  List<Products>? products;

  GroceryHomeTagsModel({this.tagId, this.tagName, this.products});

  GroceryHomeTagsModel.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_name'] = this.tagName;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? name;
  String? combo;
  String? image;
  int? price;
  String? offers;
  String? weight;
  String? variant;
  int? groceryId;
  int? salePrice;
  String? description;
  int? regularPrice;
  List<VariantsItems>? variantsItems;
  String? comboDescription;

  Products(
      {this.name,
      this.combo,
      this.image,
      this.price,
      this.offers,
      this.weight,
      this.variant,
      this.groceryId,
      this.salePrice,
      this.description,
      this.regularPrice,
      this.variantsItems,
      this.comboDescription});

  Products.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    combo = json['combo'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    weight = json['weight'];
    variant = json['variant'];
    groceryId = json['grocery_id'];
    salePrice = json['sale_price'];
    description = json['description'];
    regularPrice = json['regular_price'];
    if (json['variants_items'] != null) {
      variantsItems = <VariantsItems>[];
      json['variants_items'].forEach((v) {
        variantsItems!.add(new VariantsItems.fromJson(v));
      });
    }
    comboDescription = json['combo_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['combo'] = this.combo;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['weight'] = this.weight;
    data['variant'] = this.variant;
    data['grocery_id'] = this.groceryId;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    if (this.variantsItems != null) {
      data['variants_items'] =
          this.variantsItems!.map((v) => v.toJson()).toList();
    }
    data['combo_description'] = this.comboDescription;
    return data;
  }
}

class VariantsItems {
  int? id;
  String? name;
  List<VariantsProducts>? variantsProducts;

  VariantsItems({this.id, this.name, this.variantsProducts});

  VariantsItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['variants_products'] != null) {
      variantsProducts = <VariantsProducts>[];
      json['variants_products'].forEach((v) {
        variantsProducts!.add(new VariantsProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.variantsProducts != null) {
      data['variants_products'] =
          this.variantsProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantsProducts {
  int? id;
  String? name;
  String? image;
  int? price;
  String? offers;
  String? weight;
  int? salePrice;
  String? description;
  int? regularPrice;
  int? offersPercentage;

  VariantsProducts(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.offers,
      this.weight,
      this.salePrice,
      this.description,
      this.regularPrice,
      this.offersPercentage});

  VariantsProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    weight = json['weight'];
    salePrice = json['sale_price'];
    description = json['description'];
    regularPrice = json['regular_price'];
    offersPercentage = json['offers_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['weight'] = this.weight;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['offers_percentage'] = this.offersPercentage;
    return data;
  }
}
