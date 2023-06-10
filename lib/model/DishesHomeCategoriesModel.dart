class DishesHomeCategoriesModel {
  int? categoryId;
  String? categoryName;
  String? image;
  String? thumbnailImage;
  String? dateCreated;
  String? dateModified;
  bool? withoutdetail;

  DishesHomeCategoriesModel(
      {this.categoryId,
      this.categoryName,
      this.image,
      this.thumbnailImage,
      this.dateCreated,
      this.dateModified,
      this.withoutdetail
      });

  DishesHomeCategoriesModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    return data;
  }
}
