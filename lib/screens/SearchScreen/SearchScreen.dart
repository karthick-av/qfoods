import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String img  = "https://res.cloudinary.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_208,h_208,c_fit/gatkkbnqizbhy8zsjahg";
  String name = "Briyani";
  String cat = "Dish";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),
               Center(
                child: SizedBox(
                  width: width * 0.90,
                  child: TextField(
                    
                    
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:    Color(0xffF0F1F5),
                                   
            prefixIcon: IconButton(icon: Icon(Icons.arrow_back_ios, color: AppColors.lightgreycolor,size: ScreenUtil().setHeight(20.0),), onPressed: (){
              Navigator.of(context).pop();
            },),          
         suffixIcon: IconButton(icon: Icon(Icons.search, color: AppColors.lightgreycolor,size: ScreenUtil().setHeight(20.0),), onPressed: (){},),
          
    enabledBorder: OutlineInputBorder(
            
             borderRadius: BorderRadius.circular(9.0),
      borderSide:  BorderSide(color: Color(0xffF0F1F5)),
   
    ),
    focusedBorder:  OutlineInputBorder(
       borderRadius: BorderRadius.circular(9.0),
    borderSide:  BorderSide(color: Color(0xffF0F1F5)),
   
    ),
     hintText: "Search Restaurant or items",
     hintStyle: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0)),
        ),
      cursorColor: AppColors.primaryColor,
                    style: TextStyle(fontSize: ScreenUtil().setHeight(14.0),  fontFamily: FONT_FAMILY,color: AppColors.blackcolor),
                  ),
                )
               ),
   SizedBox(height: 20.0,),
           
               Expanded(
                 child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(14.0),
                  itemCount: 15,
                  itemBuilder: ((context, index) {
                   return Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     Container(
  width: ScreenUtil().setHeight(50.0),
  height: ScreenUtil().setHeight(50.0),
  decoration: BoxDecoration(
	shape: BoxShape.circle,
	image: DecorationImage(
	  image: NetworkImage(img),
	  fit: BoxFit.fill
	),
  ),
),

Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
  
          Text(name, style: TextStyle(color: AppColors.blackcolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setHeight(13.0)),),
   Text(cat, style: TextStyle(color: AppColors.lightgreycolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setHeight(13.0)),),
  
    ],
  
  ),
)
                    ],),
                   );
                 })),
               )
            ],
          ),
        ),
      ),
    );
  }
}