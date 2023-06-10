class CheckOutModel{
  String? address1;
  String? address2;
  String? AreaAndFloor;
  String? landMark;
  double? latitude;
  double? longitude;
  String? alternate_phone_number;
  String? instructions;

  CheckOutModel({required this.address1,required this.address2,required this.AreaAndFloor,required this.landMark,required this.latitude,required this.longitude, required this.alternate_phone_number, required this.instructions});
}

class CheckouttotalModel {
  String? kms;
  String? total;
  String? subTotal;
  String? couponCode;
  String? couponAmount;
  List<PaymentMethod>? paymentMethod;
  String? deliveryCharges;

  CheckouttotalModel(
      {this.kms,
      this.total,
      this.subTotal,
      this.paymentMethod,
      this.deliveryCharges,
      this.couponCode,
      this.couponAmount
      });

  CheckouttotalModel.fromJson(Map<String, dynamic> json) {
    kms = json['kms'];
    total = json['total'];
    subTotal = json['sub_total'];
    couponAmount= json['coupon_amount'];
    couponCode = json['coupon_code'];
    if (json['payment_method'] != null) {
      paymentMethod = <PaymentMethod>[];
      json['payment_method'].forEach((v) {
        paymentMethod!.add(new PaymentMethod.fromJson(v));
      });
    }
    deliveryCharges = json['delivery_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kms'] = this.kms;
    data['total'] = this.total;
    data['sub_total'] = this.subTotal;
    data['coupon_code'] = this.couponCode;
    data['coupon_amount'] = this.couponAmount;
    if (this.paymentMethod != null) {
      data['payment_method'] =
          this.paymentMethod!.map((v) => v.toJson()).toList();
    }
    data['delivery_charges'] = this.deliveryCharges;
    return data;
  }
}

class PaymentMethod {
  int? paymentId;
  String? paymentName;

  PaymentMethod({this.paymentId, this.paymentName});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    paymentName = json['payment_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['payment_name'] = this.paymentName;
    return data;
  }
}
