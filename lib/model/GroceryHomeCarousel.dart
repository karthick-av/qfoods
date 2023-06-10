class GroceryHomeCarousel {
  int? id;
  String? image;
  String? type;
  int? typeId;

  GroceryHomeCarousel({this.id, this.image, this.type, this.typeId});

  GroceryHomeCarousel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    return data;
  }
}
