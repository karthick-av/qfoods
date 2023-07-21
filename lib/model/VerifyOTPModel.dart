class VerifyOTPModel {
  bool? isNewUser;
  Detail? detail;

  VerifyOTPModel({this.isNewUser, this.detail});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    isNewUser = json['isNewUser'];
    detail =
        json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNewUser'] = this.isNewUser;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    return data;
  }
}

class Detail {
  int? userId;
  String? name;
  int? phoneNumber;
  String? email;

  Detail({this.userId, this.name, this.phoneNumber, this.email});

  Detail.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    return data;
  }
}
