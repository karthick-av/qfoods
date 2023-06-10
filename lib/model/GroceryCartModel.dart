class GroceryCartModel {
  String? total;
  List<Items>? items;

  GroceryCartModel({this.total, this.items});

  GroceryCartModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
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
  String? productName;
  int? groceryId;
  int? variantid;
  String? name;
  String? description;
  String? image;
  int? price;
  int? regularPrice;
  int? salePrice;
  String? weight;
  int? offers;
  int? quantity;
  int? total;
  String? variantsTotalQuantity;
  int? variantsTotal;
  int? status;

  Items(
      {this.cartId,
      this.id,
      this.productName,
      this.groceryId,
      this.variantid,
      this.name,
      this.description,
      this.image,
      this.price,
      this.regularPrice,
      this.salePrice,
      this.weight,
      this.offers,
      this.quantity,
      this.total,
      this.variantsTotalQuantity,
      this.variantsTotal,
      this.status});

  Items.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    id = json['id'];
    productName = json['product_name'];
    groceryId = json['grocery_id'];
    variantid = json['variantid'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    weight = json['weight'];
    offers = json['offers'];
    quantity = json['quantity'];
    total = json['total'];
    variantsTotalQuantity = json['variants_total_quantity'];
    variantsTotal = json['variants_total'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['grocery_id'] = this.groceryId;
    data['variantid'] = this.variantid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['weight'] = this.weight;
    data['offers'] = this.offers;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['variants_total_quantity'] = this.variantsTotalQuantity;
    data['variants_total'] = this.variantsTotal;
    data['status'] = this.status;
    return data;
  }
}
