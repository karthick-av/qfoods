

import 'package:get/get.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/Messages.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/model/CartModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CartServices{
  Future<CartModel> getCart() async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
   CartModel cartModel = CartModel();
   
  if(user_id == null) cartModel;
    final uri = Uri.parse(ApiServices.get_cart + user_id!.toString());
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(responseJson);
       final responseData =  CartModel.fromJson(responseJson);
       if(responseData.items!.length > 0){
        cartModel = responseData;
       }
    }
    return cartModel;
  }


  
 Future<CartModel> addCart(dynamic data) async{
    CartModel cartModel = CartModel();
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
    if(user_id == null) cartModel;
    String userid = user_id!.toString();
    print("userid");
    final uri = Uri.parse(ApiServices.add_cart);
    print(uri?.toString());
    var jsonString = json.encode(data);
    print(jsonString);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.post(uri, body: jsonString, headers: header);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      cartModel.total = "0";
      cartModel.items = [];
      return cartModel;
     }
       final responseData =  CartModel.fromJson(responseJson);
       if(responseData.items != null){
        cartModel = responseData;
       }
    }
    return cartModel;
  }

Future<CartModel> DeleteProduct(dynamic data) async{
    CartModel cartModel = CartModel();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
    if(user_id == null) cartModel;
    String userid = user_id!.toString();
    print("userid");
    final uri = Uri.parse(ApiServices.delete_product);
    print(uri?.toString());
    var jsonString = json.encode(data);
    print(jsonString);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.delete(uri, body: jsonString, headers: header);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      cartModel.total = "0";
      cartModel.items = [];
      return cartModel;
     }
       final responseData =  CartModel.fromJson(responseJson);
       if(responseData.items != null){
        cartModel = responseData;
       }
    }
    return cartModel;
  }

  Future<CartModel> UpdateQuantity(String cart_id, String type) async{
    CartModel _cartModel = CartModel();
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
    if(user_id == null) _cartModel;
    String userid = user_id!.toString();
    final uri = Uri.parse("${ApiServices.update_quantity}${userid}/${cart_id}?type=${type}");
   
    final response = await http.get(uri);
   if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if(responseJson?["message"] == Messages.Maximum_quantity){
         CustomSnackBar().MaximumQuantitySnackBar();
      }

     if(responseJson?["total"] == 0){
      _cartModel.total = "0";
      _cartModel.items = [];
      return _cartModel;
     }
       final responseData =  CartModel.fromJson(responseJson);
       if(responseData.items != null){
        _cartModel = responseData;
       }
    }
    return _cartModel;
  }



  Future<CartModel> UpdateVariant(dynamic data) async{
 CartModel cartModel = CartModel();
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
    if(user_id == null) cartModel;
    String userid = user_id!.toString();
    print("userid");
    final uri = Uri.parse(ApiServices.update_variant);
    print(uri?.toString());
    var jsonString = json.encode(data);
    print(jsonString);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(uri, body: jsonString, headers: header);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      cartModel.total = "0";
      cartModel.items = [];
      return cartModel;
     }
       final responseData =  CartModel.fromJson(responseJson);
       if(responseData.items != null){
        cartModel = responseData;
       }
    }
    return cartModel;
   }

}
