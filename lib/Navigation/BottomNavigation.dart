
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/screens/CartScreen/CartScreen.dart';
import 'package:qfoods/screens/Home/HomeScreen.dart';
import 'package:qfoods/screens/MyAccountScreen/MyAccountScreen.dart';
import 'package:qfoods/screens/groceryScreen/groceryScreen.dart';


class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
 int i = 0;
 

List pages = [
 HomeScreen(),
 GroceryScreen(),
 MyAccountScreen()
];

void _onItemTapped(int index) {
    setState(() {
      i = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[i],
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whitecolor,
        elevation: 0.0,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greycolor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontFamily: FONT_FAMILY),
        unselectedLabelStyle: TextStyle(fontFamily: FONT_FAMILY),
        iconSize: ScreenUtil().setSp(25.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.yard),
            label: 'Grocery',
          ),
        
           BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
        ],
        currentIndex: i,
        onTap: _onItemTapped,
      ),
       );
  }
}