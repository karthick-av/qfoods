class GroceryTagDetailModel {
  int? tagId;
  String? tagName;
  String? image;
  String? thumbnailImage;
  List<Selected>? selected;
  List<Filters>? filters;

  GroceryTagDetailModel(
      {this.tagId,
      this.tagName,
      this.image,
      this.thumbnailImage,
      this.selected,
      this.filters});

  GroceryTagDetailModel.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    if (json['selected'] != null) {
      selected = <Selected>[];
      json['selected'].forEach((v) {
        selected!.add(new Selected.fromJson(v));
      });
    }
    if (json['filters'] != null) {
      filters = <Filters>[];
      json['filters'].forEach((v) {
        filters!.add(new Filters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_name'] = this.tagName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    if (this.selected != null) {
      data['selected'] = this.selected!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Selected {
  String? name;
  List<int>? selected;

  Selected({this.name, this.selected});

  Selected.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    selected = json['selected'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}

class Filters {
  String? name;
  List<Items>? items;

  Filters({this.name, this.items});

  Filters.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  int? count;

  Items({this.id, this.name, this.count});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}
