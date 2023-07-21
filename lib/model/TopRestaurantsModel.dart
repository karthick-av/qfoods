class TopRestaurantsModel {
  int? id;
  int? restaurantId;
  int? visible;
  String? restaurantName;
  String? shortDescription;
  String? description;
  String? image;
  String? address;
  String? phoneNumber;
  String? rating;
  int? status;

  TopRestaurantsModel(
      {this.id,
      this.restaurantId,
      this.visible,
      this.restaurantName,
      this.shortDescription,
      this.rating,
      this.description,
      this.image,
      this.address,
      this.phoneNumber,
      this.status});

  TopRestaurantsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    visible = json['visible'];
    restaurantName = json['restaurant_name'];
    shortDescription = json['short_description'];
    description = json['description'];
    image = json['image'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['visible'] = this.visible;
    data['restaurant_name'] = this.restaurantName;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['image'] = this.image;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['rating'] = this.rating;
    return data;
  }
}
