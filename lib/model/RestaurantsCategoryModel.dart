class RestaurantsCategoryModel {
  int? restaurantId;
  String? restaurantName;
  String? shortDescription;
  String? description;
  String? image;
  String? address;
  int? status;

  RestaurantsCategoryModel(
      {this.restaurantId,
      this.restaurantName,
      this.shortDescription,
      this.description,
      this.image,
      this.address,
      this.status
      });

  RestaurantsCategoryModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    shortDescription = json['short_description'];
    description = json['description'];
    image = json['image'];
    address = json['address'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['image'] = this.image;
    data['address'] = this.address;
    data['status'] = this.status;
    return data;
  }
}
