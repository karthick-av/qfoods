import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryHomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/screens/CategoryScreen/CategoryScreen.dart';
import 'package:qfoods/screens/GroceryCategoriesScreen/GroceryCategoriesScreen.dart';
class CategoryGroceryWidget extends StatefulWidget {
  const CategoryGroceryWidget({super.key});

  @override
  State<CategoryGroceryWidget> createState() => _CategoryGroceryWidgetState();
}

class _CategoryGroceryWidgetState extends State<CategoryGroceryWidget> {
 @override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       if(Provider.of<GroceryHomeProvider>(context, listen: false)?.homeCategories?.length == 0){
     Provider.of<GroceryHomeProvider>(context, listen: false).getHomeCategories();
       }
    });
    super.initState();
   
   
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double swidth = width * 0.95;
    int Count = swidth ~/ ScreenUtil().setWidth(85.0).toInt();
    final homeProvider =  Provider.of<GroceryHomeProvider>(context, listen: true);
  
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Top Categories",style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(15.0), fontWeight: FontWeight.bold),),
            ),

          
          GridView.builder(
            
            itemCount: homeProvider.homeCategories?.length,
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,
            childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.5),
              
            ), 
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: (){
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroceryCategoriesScreen(groceryHomeCategories: homeProvider.homeCategories[index])),
            );
              },
              child: Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(homeProvider.homeCategories?[index]?.image!.toString() ?? '', height: ScreenUtil().setHeight(50.0),fit: BoxFit.contain,),
                     SizedBox(height: 4.0,),
                    Text(homeProvider.homeCategories?[index]?.categoryName?.toString() ?? '', textAlign: TextAlign.center,style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(11.0)),)
                 ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}