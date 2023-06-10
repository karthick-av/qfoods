class GroeryVariantItemModel {
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

  GroeryVariantItemModel(
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

  GroeryVariantItemModel.fromJson(Map<String, dynamic> json) {
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