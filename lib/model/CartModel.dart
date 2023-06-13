class CartModel {
  String? total;
  List<Items>? items;

  CartModel({this.total, this.items});

  CartModel.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? "0";
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? cartId;
  int? id;
  int? restaurantId;
  String? restaurantName;
  String? name;
  String? image;
  int? quantity;
  int? status;
  int? price;
  int? salePrice;
  int? regularPrice;
  int? combo;
  String? comboDescription;
  String? weight;
  String? variantsName;
  String? total;
  int ? variantItemsStatus;
  List<Variants>? variants;
  List<DishVariants>? dishVariants;

  Items(
      {this.cartId,
      this.id,
      this.restaurantId,
      this.restaurantName,
      this.name,
      this.variantItemsStatus,
      this.image,
      this.quantity,
      this.status,
      this.price,
      this.salePrice,
      this.regularPrice,
      this.combo,
      this.comboDescription,
      this.weight,
      this.variantsName,
      this.total,
      this.variants,
      this.dishVariants});

  Items.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    id = json['id'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    name = json['name'];
    image = json['image'];
    quantity = json['quantity'];
    status = json['status'];
    price = json['price'];
    salePrice = json['sale_price'];
    regularPrice = json['regular_price'];
    combo = json['combo'];
    comboDescription = json['combo_description'];
    weight = json['weight'];
    variantsName = json['variants_name'];
    total = json['total'];
    variantItemsStatus = json['variant_items_status'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
    if (json['dish_variants'] != null) {
      dishVariants = <DishVariants>[];
      json['dish_variants'].forEach((v) {
        dishVariants!.add(new DishVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['name'] = this.name;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['regular_price'] = this.regularPrice;
    data['combo'] = this.combo;
    data['combo_description'] = this.comboDescription;
    data['weight'] = this.weight;
    data['variants_name'] = this.variantsName;
    data['total'] = this.total;
    data['variant_items_status'] = this.variantItemsStatus;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    if (this.dishVariants != null) {
      data['dish_variants'] =
          this.dishVariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  int? variantId;
  int? variantItemId;

  Variants({this.variantId, this.variantItemId});

  Variants.fromJson(Map<String, dynamic> json) {
    variantId = json['variant_id'];
    variantItemId = json['variant_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant_id'] = this.variantId;
    data['variant_item_id'] = this.variantItemId;
    return data;
  }
}

class DishVariants {
  String? name;
  String? type;
  int? priceType;
  int? variantId;
  List<VariantItems>? variantItems;

  DishVariants(
      {this.name,
      this.type,
      this.priceType,
      this.variantId,
      this.variantItems});

  DishVariants.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    priceType = json['price_type'];
    variantId = json['variant_id'];
    if (json['variant_items'] != null) {
      variantItems = <VariantItems>[];
      json['variant_items'].forEach((v) {
        variantItems!.add(new VariantItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['price_type'] = this.priceType;
    data['variant_id'] = this.variantId;
    if (this.variantItems != null) {
      data['variant_items'] =
          this.variantItems!.map((v) => v.toJson()).toList();
    }
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
  int? status;

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
      this.status,
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
    status = json['status'];
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
    data['status'] = this.status;
    return data;
  }
}
