import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/HomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/DishesHomeCategoriesModel.dart';
import 'package:qfoods/screens/CategoryScreen/CategoryScreen.dart';
import 'package:shimmer/shimmer.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
@override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Provider.of<HomeProvider>(context, listen: false).DishesHomeCategories?.length == 0){
      Provider.of<HomeProvider>(context, listen: false).getHomeCategories();
      }
    });
    super.initState();
   
   
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double swidth = width * 0.95;
    int Count = swidth ~/ ScreenUtil().setWidth(85.0).toInt();
  final homeProvider =  Provider.of<HomeProvider>(context, listen: true);
   
    return 
    homeProvider.CatgoryLoading
    ? Loading()
    :
    Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Top Categories",style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(15.0), fontWeight: FontWeight.bold),),
            ),

          
          GridView.builder(
            
            itemCount: homeProvider?.DishesHomeCategories?.length ?? 0,
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Count,
            childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.7),
              
            ), 
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: (){
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen(dishesHomeCategoriesModel: homeProvider.DishesHomeCategories[index],)),
            );
              },
              child: Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        height: ScreenUtil().setHeight(60.0),
                        child: Image.network("${homeProvider?.DishesHomeCategories?[index]?.image ?? ""}", height: ScreenUtil().setHeight(60.0),fit: BoxFit.contain,))),
                     SizedBox(height: 4.0,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Text("${homeProvider?.DishesHomeCategories?[index]?.categoryName ?? ""}", 
                      maxLines: 1, overflow: TextOverflow.ellipsis
                      ,textAlign: TextAlign.center,style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(13.0)),),
                    )
                 ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }




  Widget Loading(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for(int i =0; i < 4 ; i++ )
              Shimmer.fromColors(child: Container(
                height: ScreenUtil().setHeight(70.0),
                width: ScreenUtil().setWidth(75.0),
               decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                         
                        ),
            ), 
               baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
              )
            ],
          ),
   SizedBox(height: ScreenUtil().setHeight(5),),

    Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for(int i =0; i < 4 ; i++ )
              Shimmer.fromColors(child: Container(
                height: ScreenUtil().setHeight(70.0),
                width: ScreenUtil().setWidth(75.0),
               decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                         
                        ),
            ), 
               baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
              )
            ],
          ),
   
              ],
      ),
    );
  }
}