class RestaurantandDishesModel {
  int? restaurantId;
  String? restaurantName;
  String? shortDescription;
  String? description;
  String? image;
  String? address;
  String? phoneNumber;
  int? status;
  String? rating;
  List<SearchResults>? searchResults;
  List<Menus>? menus;

  RestaurantandDishesModel(
      {this.restaurantId,
      this.restaurantName,
      this.shortDescription,
      this.description,
      this.image,
      this.address,
      this.phoneNumber,
      this.status,
      this.rating,
      this.searchResults,
      this.menus});

  RestaurantandDishesModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    shortDescription = json['short_description'];
    description = json['description'];
    image = json['image'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    rating = json['rating'];
    if (json['search_results'] != null) {
      searchResults = <SearchResults>[];
      json['search_results'].forEach((v) {
        searchResults!.add(new SearchResults.fromJson(v));
      });
    }
    if (json['menus'] != null) {
      menus = <Menus>[];
      json['menus'].forEach((v) {
        menus!.add(new Menus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['image'] = this.image;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['rating']  = this.rating;
    if (this.searchResults != null) {
      data['search_results'] =
          this.searchResults!.map((v) => v.toJson()).toList();
    }
    if (this.menus != null) {
      data['menus'] = this.menus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchResults {

  
  String? name;
  int? combo;
  String? image;
  int? price;
  String? offers;
  String? weight;
  int? dishId;
  int? salePrice;
  String? description;
  List<DishVariants>? dishVariants;
  int? regularPrice;
  int? restaurantId;
  String? comboDescription;
  int? offersPercentage;
  String? variant;
  int? status;

  SearchResults(
      {this.name,
      this.combo,
      this.image,
      this.price,
      this.offers,
      this.weight,
      this.dishId,
      this.salePrice,
      this.description,
      this.dishVariants,
      this.regularPrice,
      this.restaurantId,
      this.comboDescription,
      this.offersPercentage,
      this.variant,
      this.status
      });

  SearchResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    combo = json['combo'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    weight = json['weight'];
    dishId = json['dish_id'];
    salePrice = json['sale_price'];
    status = json ['status'];
    description = json['description'];
    if (json['dish_variants'] != null) {
      dishVariants = <DishVariants>[];
      json['dish_variants'].forEach((v) {
        dishVariants!.add(new DishVariants.fromJson(v));
      });
    }
    regularPrice = json['regular_price'];
    restaurantId = json['restaurant_id'];
    comboDescription = json['combo_description'];
    offersPercentage = json['offers_percentage'];
    variant = json["variant"];
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
    data['status'] = this.status;
    if (this.dishVariants != null) {
      data['dish_variants'] =
          this.dishVariants!.map((v) => v.toJson()).toList();
    }
    data['regular_price'] = this.regularPrice;
    data['restaurant_id'] = this.restaurantId;
    data['combo_description'] = this.comboDescription;
    data['offers_percentage'] = this.offersPercentage;
    data['variant'] = this.variant;
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

class Menus {
  List<SearchResults>? dishes;
  int? menuId;
  String? menuName;

  Menus({this.dishes, this.menuId, this.menuName});

  Menus.fromJson(Map<String, dynamic> json) {
    if (json['dishes'] != null) {
      dishes = <SearchResults>[];
      json['dishes'].forEach((v) {
        dishes!.add(new SearchResults.fromJson(v));
      });
    }
    menuId = json['menu_id'];
    menuName = json['menu_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dishes != null) {
      data['dishes'] = this.dishes!.map((v) => v.toJson()).toList();
    }
    data['menu_id'] = this.menuId;
    data['menu_name'] = this.menuName;
    return data;
  }
}
