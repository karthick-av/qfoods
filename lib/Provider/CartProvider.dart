import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:qfoods/helpers/cart_helpers.dart';
import 'package:qfoods/model/CartModel.dart';

class CartProvider extends ChangeNotifier {
  final _service = CartServices();
bool isLoading = false;
 var loadingId = "";
 CartModel _cartModel = CartModel();

  CartModel get CartData => _cartModel;


  Future<void> getCart() async{
   isLoading = true;
    notifyListeners();

 try{
     CartModel response = await _service.getCart();
  
  if(response.items != null){
     _cartModel = response;
  }
   
    isLoading = false;
    notifyListeners();
 }
 catch(e){
    isLoading = false;
    notifyListeners();
    print(e);
 }
  } 


Future<void> addCart(dynamic data) async{

    loadingId =data!["product_id"]!.toString();
    notifyListeners();


    print("dd");
    print(data);
    
   try{
      CartModel response = await _service.addCart(data);
    loadingId = "";
    notifyListeners();

 if(response.items != null){
      _cartModel = response;
      print(jsonEncode(response.items));
    notifyListeners();
  }
   }
   catch(e){
     loadingId = "";
    notifyListeners();
   }
  }


Future<void> deleteProduct(dynamic data) async{

    // loadingId =data!["product_id"]!.toString();
    // notifyListeners();


    print("dd");
    print(data);
    
   try{
      CartModel response = await _service.DeleteProduct(data);
    loadingId = "";
    notifyListeners();

 if(response.items != null){
      _cartModel = response;
      print(jsonEncode(response.items));
    notifyListeners();
  }
   }
   catch(e){
     loadingId = "";
    notifyListeners();
   }
  }

Future<void> updateVariant(dynamic data) async{

    loadingId =data!["product_id"]!.toString();
    notifyListeners();


    print("dd");
    print(data);
    
   try{
      CartModel response = await _service.UpdateVariant(data);
    loadingId = "";
    notifyListeners();

 if(response.items != null){
      _cartModel = response;
    notifyListeners();
  }
   }
   catch(e){
     loadingId = "";
    notifyListeners();
   }
  }


  Future<void> updateQuantity(String cart_id, String type,String loadingid) async{
     loadingId = loadingid;
    notifyListeners();

    print(cart_id);
   
    try{
       CartModel response = await _service.UpdateQuantity(cart_id, type);
  loadingId = "";
    notifyListeners();
 
  if(response.items != null){
     _cartModel = response;
    notifyListeners();
  }
  
    }
    catch(e){
       loadingId = "";
    notifyListeners();
    }
     
  }

  Future<void> AddLoadingid(String id) async{
    loadingId = id;
    notifyListeners();
  }

  
  Future<void> AddCartData(CartModel cartData) async{
   if(cartData.items != null){
      _cartModel = cartData;
    notifyListeners();
  }
  }


}
