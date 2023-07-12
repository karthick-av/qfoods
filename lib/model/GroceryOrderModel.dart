class GroceryOrderModel {
  int? orderId;
  int? userId;
  String? subTotal;
  String? deliveryCharges;
  String? grandTotal;
  int? status;
  int? isCancelled;
  int? isDelivered;
  int? isReviewed;
  int? isDeliveryPersonRating;
  int? deliveryPersonId;
  String? orderCreated;
  Address? address;
  PaymentDetail? paymentDetail;
  List<OrderStatus>? orderStatus;
  List<Items>? items;
  DeliveryPersonDetail? deliveryPersonDetail;
  CancelDetail? cancelDetail;

  GroceryOrderModel(
      {this.orderId,
      this.userId,
      this.subTotal,
      this.deliveryCharges,
      this.grandTotal,
      this.status,
      this.isReviewed,
      this.isDeliveryPersonRating,
      this.isCancelled,
      this.isDelivered,
      this.deliveryPersonId,
      this.orderCreated,
      this.address,
      this.paymentDetail,
      this.orderStatus,
      this.items,
      this.deliveryPersonDetail,
      this.cancelDetail});

  GroceryOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    subTotal = json['sub_total'];
    deliveryCharges = json['delivery_charges'];
    grandTotal = json['grand_total'];
    status = json['status'];
    isCancelled = json['isCancelled'];
    isDelivered = json['isDelivered'];
    isReviewed = json['isReviewed'];
    isDeliveryPersonRating = json['isDeliveryPersonRating'];
    deliveryPersonId = json['delivery_person_id'];
    orderCreated = json['order_created'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    paymentDetail = json['payment_detail'] != null
        ? new PaymentDetail.fromJson(json['payment_detail'])
        : null;
    if (json['order_status'] != null) {
      orderStatus = <OrderStatus>[];
      json['order_status'].forEach((v) {
        orderStatus!.add(new OrderStatus.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    deliveryPersonDetail = json['delivery_person_detail'] != null
        ? new DeliveryPersonDetail.fromJson(json['delivery_person_detail'])
        : null;
    cancelDetail = json['cancel_detail'] != null
        ? new CancelDetail.fromJson(json['cancel_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['sub_total'] = this.subTotal;
    data['delivery_charges'] = this.deliveryCharges;
    data['grand_total'] = this.grandTotal;
    data['status'] = this.status;
    data['isReviewed'] = this.isReviewed;
    data['isDeliveryPersonRating'] = this.isDeliveryPersonRating;
    data['isCancelled'] = this.isCancelled;
    data['isDelivered'] = this.isDelivered;
    data['delivery_person_id'] = this.deliveryPersonId;
    data['order_created'] = this.orderCreated;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.paymentDetail != null) {
      data['payment_detail'] = this.paymentDetail!.toJson();
    }
    if (this.orderStatus != null) {
      data['order_status'] = this.orderStatus!.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryPersonDetail != null) {
      data['delivery_person_detail'] = this.deliveryPersonDetail!.toJson();
    }
    if (this.cancelDetail != null) {
      data['cancel_detail'] = this.cancelDetail!.toJson();
    }
    return data;
  }
}

class Address {
  String? address1;
  String? address2;
  String? landmark;
  String? latitude;
  String? longitude;
  String? alternatePhoneNumber;

  Address(
      {this.address1,
      this.address2,
      this.landmark,
      this.latitude,
      this.longitude,
      this.alternatePhoneNumber});

  Address.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    alternatePhoneNumber = json['alternate_phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['landmark'] = this.landmark;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['alternate_phone_number'] = this.alternatePhoneNumber;
    return data;
  }
}

class PaymentDetail {
  int? paymentId;
  String? paymentName;

  PaymentDetail({this.paymentId, this.paymentName});

  PaymentDetail.fromJson(Map<String, dynamic> json) {
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

class OrderStatus {
  String? status;
  int? statusId;
  String? updatedAt;

  OrderStatus({this.status, this.statusId, this.updatedAt});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusId = json['status_id'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_id'] = this.statusId;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Items {
  String? name;
  int? price;
  int? total;
  int? cartId;
  int? quantity;
  int? productId;
  int? variantId;
  String? productName;

  Items(
      {this.name,
      this.price,
      this.total,
      this.cartId,
      this.quantity,
      this.productId,
      this.variantId,
      this.productName});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    total = json['total'];
    cartId = json['cart_id'];
    quantity = json['quantity'];
    productId = json['product_id'];
    variantId = json['variant_id'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['total'] = this.total;
    data['cart_id'] = this.cartId;
    data['quantity'] = this.quantity;
    data['product_id'] = this.productId;
    data['variant_id'] = this.variantId;
    data['product_name'] = this.productName;
    return data;
  }
}

class DeliveryPersonDetail {
  String? name;
  String? image;
  int? phoneNumber;

  DeliveryPersonDetail({this.name, this.image, this.phoneNumber});

  DeliveryPersonDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class CancelDetail {
  int? cancelId;
  String? cancelledAt;
  String? cancelledReason;

  CancelDetail({this.cancelId, this.cancelledAt, this.cancelledReason});

  CancelDetail.fromJson(Map<String, dynamic> json) {
    cancelId = json['cancel_id'];
    cancelledAt = json['cancelled_at'];
    cancelledReason = json['cancelled_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancel_id'] = this.cancelId;
    data['cancelled_at'] = this.cancelledAt;
    data['cancelled_reason'] = this.cancelledReason;
    return data;
  }
}
