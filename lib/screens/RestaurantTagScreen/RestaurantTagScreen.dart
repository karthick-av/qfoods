
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/FilterSelectedProvider.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/filter_list.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/RestaurantTag.dart';
import 'package:qfoods/model/RestaurantsCategoryModel.dart';

import 'package:http/http.dart' as http;
import 'package:qfoods/widgets/RestaurantCardLoading.dart';
import 'package:qfoods/widgets/RestaurantfilterBottomSheet.dart';
import 'package:qfoods/widgets/RestaurantsCategoryCard.dart';
import 'package:qfoods/widgets/ShimmerContainer.dart';


class RestaurantTagScreen extends StatefulWidget {
  final RestaurantTag restaurantTag;
  const RestaurantTagScreen({super.key, required this.restaurantTag});

  @override
  State<RestaurantTagScreen> createState() => _RestaurantTagScreenState();
}

class _RestaurantTagScreenState extends State<RestaurantTagScreen> {
ScrollController scrollController = ScrollController();
List<RestaurantsCategoryModel> Restaurants = [];
RestaurantTag? tag;
bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 7;
bool loading = false;
bool footer_loading = false;
bool header_loading = false;

 
  var opacityValue = 0.0;

  @override
  void initState() {
     Provider.of<FilterSelectedProvider>(context, listen: false).ClearRestaurantFilterHandler();

     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tag = widget.restaurantTag;
      setState(() { });
     if(widget.restaurantTag?.withoutdetail ?? false){
       DishTagDetailHandler();
     }
    });
    scrollController.addListener(() { //listener 
     if(scrollController.position.maxScrollExtent == scrollController.offset){
      print("object");
       if(!ApiCallDone){
        BottomRestaurantsTagIdHandler();
       }
    }
     
    double val = double.parse((scrollController.offset.toInt() / ScreenUtil().setHeight(60.0).toInt()).toStringAsFixed(1));
  print(val);
    if(val <= 1.0){
    setState(() {
       
       opacityValue = val;
     });
   
    }
     
 
    });
    RestaurantsByTagIdHandler();
    super.initState();
  }


void dispose(){
  
  scrollController.dispose();
  super.dispose();
}


Future<void> DishTagDetailHandler() async{
  RestaurantTag _tag;
  header_loading= true;
  setState(() { });
try{
    var response = await http.get(Uri.parse("${ApiServices.restaurant_tag_detail}${widget?.restaurantTag?.tagId}"));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       _tag = RestaurantTag.fromJson(response_body);

       tag = _tag;
       header_loading = false;
       setState(() { });
    
    }
  }
  catch(err){
  }

}

String APIURL(){
final filter = Provider.of<FilterSelectedProvider>(context, listen: false).RestaurantFilter;

  String Url = "${ApiServices.restaurant_tag_by_id}${widget.restaurantTag?.tagId}?page=${current_page}&per_page=${per_page}";

for(var i = 0; i < filter.length; i++){
  if(filter[i]?.selected != ""){
final opt = filter[i]?.options;
      
   if(filter[i]?.filter_type == "veg"){
      final option = opt?.firstWhere((ele) => ele.attribute_id?.toString() == filter[i]?.selected);
         if(option?.value !=  null){
          Url += "&veg_type=${option?.type}";
         }
   }

    if(filter[i]?.filter_type == "sort"){
      final option = opt?.firstWhere((ele) => ele.attribute_id?.toString() == filter[i]?.selected);
      if(option?.value != null && option?.type != null){
         Url += "&order=${option?.value}&orderby=${option?.type}";
      }
  }
 if(filter[i]?.filter_type == "price"){
      final option = opt?.firstWhere((ele) => ele.attribute_id?.toString() == filter[i]?.selected);
      if(option?.minPrice != null && option?.maxPrice != null){
      Url += "&price_type=between&min_price=${option?.minPrice}&max_price=${option?.maxPrice}";
      }
        if(option?.value != null && option?.type != null){
          Url += "&price_type=sort&sort_price=${option?.value}&sort_type=${option?.type}";
       }
 }

}
}
return Url;
}

Future<void> FilterTagHandler()async {

  List<RestaurantsCategoryModel> _restaurants= [];
 ApiCallDone = false;
 current_page = 1;
 CompleteAPI = false;
 per_page = 7;
 loading = true;
 footer_loading = false;
 header_loading = false;

  setState(() {
  });
try{



  
    var response = await http.get(Uri.parse(APIURL()));
    print(response.statusCode);
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      _restaurants.add(RestaurantsCategoryModel.fromJson(json));
       }
 Restaurants= _restaurants;
         current_page = current_page + 1;
         loading = false;


       setState(() {
        
       });
    }
  }
  catch(err){

  }
  
}


Future<void> RestaurantsByTagIdHandler()async {
  List<RestaurantsCategoryModel> _restaurants= [];
  setState(() {
    loading = true;
  });
try{
    var response = await http.get(Uri.parse("${ApiServices.restaurant_tag_by_id}${widget.restaurantTag?.tagId}?page=${current_page}&per_page=${per_page}"));
    print(response.statusCode);
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      _restaurants.add(RestaurantsCategoryModel.fromJson(json));
       }
 Restaurants= _restaurants;
         current_page = current_page + 1;
         loading = false;


       setState(() {
        
       });
    }
  }
  catch(err){

  }
  
}

Future<void> BottomRestaurantsTagIdHandler()async {
  print(current_page);
  if(CompleteAPI) return;

  List<RestaurantsCategoryModel> _restaurants= [];
  setState(() {
    footer_loading = true;
    ApiCallDone = true;
  });
try{
  
  var response = await http.get(Uri.parse(APIURL()));
      print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);

       if(response_body!.length == 0){
        setState(() {
          CompleteAPI = true;
        });
       }
       
       for(var json in response_body){
     
      _restaurants.add(RestaurantsCategoryModel.fromJson(json));
       }

       setState(() {
         footer_loading = false;
    current_page = current_page + 1;
    ApiCallDone = false;
 
         Restaurants=  [...Restaurants, ..._restaurants];
      


       });
    }else{
      setState(() {
    ApiCallDone = false;
  });
    }
  }
  catch(err){
 setState(() {
    ApiCallDone = false;
  });
  }
  
}


  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * 0.90;
final filter = Provider.of<FilterSelectedProvider>(context, listen: false);
int selectedCount = filter.isSelected  ? filter.RestaurantFilter.where((e) => e.selected != "").length : 0;
print("${tag?.thumbnailImage}  tag");
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SafeArea(child: Stack(
        alignment: Alignment.topCenter,
        children: [
       
          CustomScrollView(
        controller: scrollController,
        slivers: [
          if(header_loading)
     SliverToBoxAdapter(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
             IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),
            
            Container(
              margin: const EdgeInsets.only(left: 18.0, top: 10),
              child: ShimmerContainer(ScreenUtil().setSp(20), ScreenUtil().setWidth(120), 5),
            ),
             Container(
              margin: const EdgeInsets.only(left: 18.0, top: 10),
              child: ShimmerContainer(ScreenUtil().setSp(20), ScreenUtil().setWidth(180), 5),
            )
      ],
     ),
       ),
     ),


     tag?.thumbnailImage == ""
     ? 

SliverToBoxAdapter(
              child: Text(""),
)      :    ( 
        tag?.thumbnailImage != null ?
        SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
           //pinned: true,
            elevation: 0.0,
            expandedHeight: ScreenUtil().setHeight(100.0),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.topLeft,
                children: [
      
                  Image.network(tag?.thumbnailImage ?? '', width: double.infinity, fit: BoxFit.cover,),
        InkWell(
onTap: (){
  
              Navigator.of(context).pop();
},
          child: Container(
           padding: const EdgeInsets.all(5.0),
           margin: const EdgeInsets.all(10.0),
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blackcolor.withOpacity(0.3)
           ),
            child: Icon(Icons.arrow_back, color: AppColors.whitecolor, size: ScreenUtil().setSp(25.0),),
          ),
        ),
                ],
              )
            ),
        
          ): SliverToBoxAdapter()),
            tag?.thumbnailImage == "" ?
           SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: Row(children: [
             IconButton(onPressed: (){
             Navigator.of(context).pop();
           }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),

           Text("${tag?.tagName ?? ''}", 
           maxLines: 1,
           overflow: TextOverflow.ellipsis
           ,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18.0), fontWeight: FontWeight.bold),)
        
             ],)
            ),
           ) :   SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: Row(children: [
            Text("${tag?.tagName ?? ''}", 
           maxLines: 1,
           overflow: TextOverflow.ellipsis
           ,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18.0), fontWeight: FontWeight.bold))
        
             ],)
            ),
           ),

  SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
               child: Row(children: [
               InkWell(
                onTap: (){
                  RestauarntFilterBottomSheet(context, FilterTagHandler);
                },
                 child: Container(
                  padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8),
                  //margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: selectedCount > 0 ? AppColors.lightgreycolor.withOpacity(0.2) : AppColors.whitecolor,
                    border: Border.all(
                      color:  AppColors.greycolor,
               
                    )
                  ),
                  child: Row(
                    children: [
                      if(selectedCount > 0)
                           Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor
                            ),
                            child: Text(selectedCount?.toString() ?? "0",
                            style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(10)),
                            ),
                           ),                  
              
             
                      Text("Filter", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.greycolor),),
                    SizedBox(width: ScreenUtil().setSp(2.0),),
                   Icon(Icons.tune, color: AppColors.greycolor, size: ScreenUtil().setSp(17),)
                    ],
                  ),
                 ),
               ),



               for(int i = 0; i < (filter_list?.length ?? 0); i++ )
               for ( var item in filter_list[i]?.options ?? [] )
               InkWell(
                onTap: (){
                  if(filter_list[i]?.selected ==  item?.attribute_id?.toString()){
       filter.SelectRestaurantHandler(i, '');
                  
                  }else{
                       filter.ApplyFilter();
                  
                  filter.SelectRestaurantHandler(i, item?.attribute_id?.toString() ?? '');
                  }
                  FilterTagHandler();
                },
                 child: Container(
                  padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8),
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: filter_list[i]?.selected ==  item?.attribute_id?.toString() ? AppColors.lightgreycolor.withOpacity(0.2) :  AppColors.whitecolor,
                    border: Border.all(
                      color:  AppColors.greycolor,
               
                    )
                  ),
                  child: Row(
                    children: [
                     
                      Text("${item?.attributeName ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.greycolor),),
                    SizedBox(width: ScreenUtil().setSp(2.0),),

                    if(filter_list[i]?.selected ==  item?.attribute_id?.toString())
                   Icon(Icons.close, color: AppColors.greycolor, size: ScreenUtil().setSp(17),)
                    ],
                  ),
                 ),
               ),
               
                  
               ],),
             )
            ),
           ),

loading
? SliverToBoxAdapter(
  child: RestaurantLoadingCard(context, 8),
)

 :         SliverPadding(
             padding: EdgeInsets.symmetric(horizontal: 14.0),
             
        sliver:  SliverList(
            
               delegate: SliverChildBuilderDelegate(
                 (BuildContext context, int index) {
                   return RestaurantsCategoryCard(
                    categoryName: tag?.tagName?.toString() ?? '',
                    restaurant: Restaurants[index], categoryId: tag?.tagName?.toString() ?? '',);
                 },
                 // 40 list items
                 childCount: Restaurants?.length ?? 0, 
               ),
             )
          ),

                SliverToBoxAdapter(child: SizedBox(height: 50.0,),),
   
           if(footer_loading)
      SliverToBoxAdapter(
        child: Center(child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
                    height: ScreenUtil().setHeight(20.0),
                    width: ScreenUtil().setWidth(20.0),
                    child:  CircularProgressIndicator(
                    color: AppColors.primaryColor

                  ),
                  ),
          ),)
      )
        ],
      ),
        if(tag?.thumbnailImage != "")
    
       AnimatedOpacity(opacity: opacityValue, duration: Duration(milliseconds: 900),
    child:  Container(
        width: double.infinity,
       padding: const EdgeInsets.only(top:5.0, left: 3.0),
        color: AppColors.whitecolor,
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),

            Text("${tag?.tagName ?? ''}", 
            maxLines: 1,
            overflow: TextOverflow.ellipsis
            ,style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setHeight(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    ),

        ],
      )
      ),
    );
  }
}