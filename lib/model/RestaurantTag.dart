class RestaurantTag {
  int? tagId;
  String? tagName;
  String? image;
  String? thumbnailImage;
  bool? withoutdetail;

  RestaurantTag(
      {this.tagId, this.tagName, this.image, this.thumbnailImage, this.withoutdetail});

  RestaurantTag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_name'] = this.tagName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    return data;
  }
}


