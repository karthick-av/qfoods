class OrderModel {
  int? orderId;
  int? userId;
  String? subTotal;
  String? deliveryCharges;
  String? grandTotal;
  int? status;
  int? isCancelled;
  int? isDelivered;
  String? orderCreated;
  int? deliveryPersonId;
  String? cookingInstructions;
  Address? address;
  PaymentDetail? paymentDetail;
  List<DishItems>? dishItems;
  List<OrderStatus>? orderStatus;
  DeliveryPersonDetail? deliveryPersonDetail;
  CancelDetail? cancelDetail;

  OrderModel(
      {this.orderId,
      this.userId,
      this.subTotal,
      this.deliveryCharges,
      this.grandTotal,
      this.status,
      this.isCancelled,
      this.isDelivered,
      this.orderCreated,
      this.deliveryPersonId,
      this.cookingInstructions,
      this.address,
      this.paymentDetail,
      this.dishItems,
      this.orderStatus,
      this.deliveryPersonDetail,
      this.cancelDetail});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    subTotal = json['sub_total'];
    deliveryCharges = json['delivery_charges'];
    grandTotal = json['grand_total'];
    status = json['status'];
    isCancelled = json['isCancelled'];
    isDelivered = json['isDelivered'];
    orderCreated = json['order_created'];
    deliveryPersonId = json['delivery_person_id'];
    cookingInstructions = json['cooking_instructions'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    paymentDetail = json['payment_detail'] != null
        ? new PaymentDetail.fromJson(json['payment_detail'])
        : null;
    if (json['dish_items'] != null) {
      dishItems = <DishItems>[];
      json['dish_items'].forEach((v) {
        dishItems!.add(new DishItems.fromJson(v));
      });
    }
    if (json['order_status'] != null) {
      orderStatus = <OrderStatus>[];
      json['order_status'].forEach((v) {
        orderStatus!.add(new OrderStatus.fromJson(v));
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
    data['isCancelled'] = this.isCancelled;
    data['isDelivered'] = this.isDelivered;
    data['order_created'] = this.orderCreated;
    data['delivery_person_id'] = this.deliveryPersonId;
    data['cooking_instructions'] = this.cookingInstructions;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.paymentDetail != null) {
      data['payment_detail'] = this.paymentDetail!.toJson();
    }
    if (this.dishItems != null) {
      data['dish_items'] = this.dishItems!.map((v) => v.toJson()).toList();
    }
    if (this.orderStatus != null) {
      data['order_status'] = this.orderStatus!.map((v) => v.toJson()).toList();
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

class DishItems {
  String? name;
  int? price;
  int? total;
  int? dishId;
  int? quantity;
  String? variantName;
  int? restaurantId;
  List<VariantItems>? variantItems;
  String? restaurantName;

  DishItems(
      {this.name,
      this.price,
      this.total,
      this.dishId,
      this.quantity,
      this.variantName,
      this.restaurantId,
      this.variantItems,
      this.restaurantName});

  DishItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    total = json['total'];
    dishId = json['dish_id'];
    quantity = json['quantity'];
    variantName = json['variant_name'];
    restaurantId = json['restaurant_id'];
    if (json['variant_items'] != null) {
      variantItems = <VariantItems>[];
      json['variant_items'].forEach((v) {
        variantItems!.add(new VariantItems.fromJson(v));
      });
    }
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['total'] = this.total;
    data['dish_id'] = this.dishId;
    data['quantity'] = this.quantity;
    data['variant_name'] = this.variantName;
    data['restaurant_id'] = this.restaurantId;
    if (this.variantItems != null) {
      data['variant_items'] =
          this.variantItems!.map((v) => v.toJson()).toList();
    }
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}

class VariantItems {
  String? name;
  int? price;
  int? variantItemId;

  VariantItems({this.name, this.price, this.variantItemId});

  VariantItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    variantItemId = json['variant_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['variant_item_id'] = this.variantItemId;
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
