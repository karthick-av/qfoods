class SelectFilter{
  String? minPrice;
  String? maxPrice;
  String? value;
  String? type;
  SelectFilter({this.minPrice, this.maxPrice, this.value, this.type}); 
}


class FilterModel {
  String? title;
  String? selected;
  String? type;
  String? filter_type;
 
  List<Options>? options;
 

  FilterModel({this.title, this.selected, this.type, this.options,
  this.filter_type
  });

  FilterModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    selected = json['selected'];
    type = json['type'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['selected'] = this.selected;
    data['type'] = this.type;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? attribute_id;
  String? attributeName;
  String? minPrice;
  String? maxPrice;
  String? value;
  String? type;


  Options({this.attributeName, this.attribute_id,
  
  this.minPrice, this.maxPrice,
  this.value, this.type
  });

  Options.fromJson(Map<String, dynamic> json) {
    attributeName = json['attribute_name'];
    attribute_id = json["attribute_id"];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_name'] = this.attributeName;
    data['attribute_id'] = this.attribute_id;
    return data;
  }
}







