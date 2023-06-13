
class ApiServices{
  ApiServices._();
    static  const BASEURL = "http://192.168.10.5:1999/";
     static const SOCKET_ORDER_URL = "${BASEURL}order";


    static const  grocery_search = "${BASEURL}user/grocery/search" ;
    static const get_cart = "${BASEURL}user/cart/";
    static const grocery_get_cart = "${BASEURL}user/cart/grocery/";
    static const grocery_add_cart = "${BASEURL}user/cart/grocery/add";
    static const grocery_variant_update_quantity = "${BASEURL}user/cart/grocery/variant/updatequantity/";
    static const grocery_home_tags = "${BASEURL}user/grocery/tags/home";
      static const grocery_home_carousel = "${BASEURL}user/grocery/tags/carousel";
   static const grocery_update_quantity = "${BASEURL}user/cart/grocery/updatequantity/";
     static const grocery_home_categories = "${BASEURL}user/grocery/categories/home";
   static const grocery_delete_product = "${BASEURL}user/cart/grocery/deleteproduct/";
   static const grocery_checkout_delete_product = "${BASEURL}user/cart/grocery/checkout/deleteproduct/";
   static const grocery_category_detail_by_id = "${BASEURL}user/grocery/categories/category/";

     static const get_product_by_category_Id = "${BASEURL}user/grocery/categories/getproductbycategoryid/";
     static const get_by_category_Id = "${BASEURL}user/restaurant/categories/";
 
  static const dishes_home_tags = "${BASEURL}user/restaurant/tags/home";
  static const top_restaurants = "${BASEURL}user/restaurant/tags/toprestaurants";

  static const dish_home_categories = "${BASEURL}user/restaurant/categories/home/list/";

  static const get_restaurants_category_id = "${BASEURL}user/restaurant/categories/getrestaurantsbycategoryid/";
  static const get_category_id = "${BASEURL}user/restaurant/categories/";
     
     static const restaurant_and_dishes = "${BASEURL}user/restaurant/restaurantanddishes/";
    
        static const add_cart = "${BASEURL}user/cart/add";
 static const update_quantity = "${BASEURL}user/cart/updatequantity/";
 static const update_variant = "${BASEURL}user/cart/updatevariant/";
 static const delete_product = "${BASEURL}user/cart/deleteproduct/";
 static const checkout_delete_product = "${BASEURL}user/cart/checkout/deleteproduct/";
 
 static const checkout_update_quantity = "${BASEURL}user/cart/checkout/updatequantity/";
  static const grocery_checkout_update_quantity = "${BASEURL}user/cart/grocery/checkout/updatequantity/";
  
  static const check_out ="${BASEURL}user/order/checkout/";
  
  static const grcoery_check_out ="${BASEURL}user/order/grocery/checkout/";
  static const create_order ="${BASEURL}user/order/createorder/";
   static const grocery_create_order ="${BASEURL}user/order/grocery/createorder/";
 

 static const grocery_tag_detail = "${BASEURL}user/grocery/tags/";
  static const grocery_by_tag_id = "${BASEURL}user/grocery/tags/product/";
  
  

  static const restaurant_home_carousel = "${BASEURL}user/restaurant/tags/home/carousel";

   static const restaurant_tag_detail ="${BASEURL}user/restaurant/tags/";

   static const restaurant_tag_by_id ="${BASEURL}user/restaurant/tags/restaurant/";


   static const get_orders = "${BASEURL}user/order/";
   static const get_grocery_orders = "${BASEURL}user/order/grocery/";
   
   
   static const get_order = "${BASEURL}user/order/getorder/";
   static const get_grocery_order = "${BASEURL}user/order/grocery/getorder/";
    
    
    static const apply_coupon = "${BASEURL}user/coupon/apply";
    
    static const update_fcmtoken = "${BASEURL}user/login/updatefcmtoken";
     }