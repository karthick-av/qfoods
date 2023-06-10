class DishesHomeTagsModel {
  String? tagName;
  List<Items>? items;

  DishesHomeTagsModel({this.tagName, this.items});

  DishesHomeTagsModel.fromJson(Map<String, dynamic> json) {
    tagName = json['tag_name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_name'] = this.tagName;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  int? combo;
  String? image;
  int? price;
  String? offers;
  String? weight;
  int? dishId;
  int? salePrice;
  String? description;
  int? regularPrice;
  int? restaurantId;
  List<VariantItems>? variantItems;
  String? restaurantName;
  String? comboDescription;
  int? offersPercentage;
  String? shortDescription;

  Items(
      {this.name,
      this.combo,
      this.image,
      this.price,
      this.offers,
      this.weight,
      this.dishId,
      this.salePrice,
      this.description,
      this.regularPrice,
      this.restaurantId,
      this.variantItems,
      this.restaurantName,
      this.comboDescription,
      this.offersPercentage,
      this.shortDescription});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    combo = json['combo'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    weight = json['weight'];
    dishId = json['dish_id'];
    salePrice = json['sale_price'];
    description = json['description'];
    regularPrice = json['regular_price'];
    restaurantId = json['restaurant_id'];
    if (json['variant_items'] != null) {
      variantItems = <VariantItems>[];
      json['variant_items'].forEach((v) {
        variantItems!.add(new VariantItems.fromJson(v));
      });
    }
    restaurantName = json['restaurant_name'];
    comboDescription = json['combo_description'];
    offersPercentage = json['offers_percentage'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['combo'] = this.combo;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['weight'] = this.weight;
    data['dish_id'] = this.dishId;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['restaurant_id'] = this.restaurantId;
    if (this.variantItems != null) {
      data['variant_items'] =
          this.variantItems!.map((v) => v.toJson()).toList();
    }
    data['restaurant_name'] = this.restaurantName;
    data['combo_description'] = this.comboDescription;
    data['offers_percentage'] = this.offersPercentage;
    data['short_description'] = this.shortDescription;
    return data;
  }
}

class VariantItems {
  String? name;
  String? image;
  int? price;
  String? offers;
  String? weight;
  int? salePrice;
  String? description;
  int? regularPrice;
  int? variantItemId;
  int? offersPercentage;

  VariantItems(
      {this.name,
      this.image,
      this.price,
      this.offers,
      this.weight,
      this.salePrice,
      this.description,
      this.regularPrice,
      this.variantItemId,
      this.offersPercentage});

  VariantItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    weight = json['weight'];
    salePrice = json['sale_price'];
    description = json['description'];
    regularPrice = json['regular_price'];
    variantItemId = json['variant_item_id'];
    offersPercentage = json['offers_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['weight'] = this.weight;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['variant_item_id'] = this.variantItemId;
    data['offers_percentage'] = this.offersPercentage;
    return data;
  }
}
