import 'package:flutter/material.dart';//安卓风格
import 'package:flutter/cupertino.dart';//ios风格ui库
// 引入tabbar页面
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/currunt_index.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs =[
     BottomNavigationBarItem(
     icon:Icon(CupertinoIcons.home),
     title:Text("首页")
    ),
    BottomNavigationBarItem(
     icon:Icon(CupertinoIcons.search),
     title:Text("分类")
    ),
    BottomNavigationBarItem(
     icon:Icon(CupertinoIcons.car),
     title:Text("购物车")
    ),
    BottomNavigationBarItem(
     icon:Icon(CupertinoIcons.profile_circled),
     title:Text("会员")
    ),
  ];
  // 声明list类型变量，存放tabbar页面
  final List<Widget> tabBodies=[
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);//屏幕适配
    return Provide<CurruntProvide>(
      builder: (context,child,val){
        int currentIndex = Provide.value<CurruntProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 22, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap:(index){
              Provide.value<CurruntProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children:tabBodies,        
          ),
        );
      },
    );
  }
}

// 创建一个动态组件
// class IndexPage extends StatefulWidget {
//   _IndexPageState createState() => _IndexPageState();
// }
 
// class _IndexPageState extends State<IndexPage> {
   // 建立一个list组件，List变量就定义了底部导航的文字和使用的图标。
//   final List<BottomNavigationBarItem> bottomTabs =[
//      BottomNavigationBarItem(
//      icon:Icon(CupertinoIcons.home),
//      title:Text("首页")
//     ),
//     BottomNavigationBarItem(
//      icon:Icon(CupertinoIcons.search),
//      title:Text("分类")
//     ),
//     BottomNavigationBarItem(
//      icon:Icon(CupertinoIcons.car),
//      title:Text("购物车")
//     ),
//     BottomNavigationBarItem(
//      icon:Icon(CupertinoIcons.profile_circled),
//      title:Text("会员")
//     ),
//   ];
//   // 声明list类型变量，存放tabbar页面
//   final List<Widget> tabBodies=[
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];
//   // 定义索引值
//   int currentIndex = 0;
//   var currentPage;
//   // 方法重写 初始化state
//   @override
//   void initState() {
//     currentPage=tabBodies[currentIndex];
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);//屏幕适配
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(244, 22, 245, 1.0),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         items: bottomTabs,
//         onTap:_check,
//       ),
//       body: IndexedStack(
//         index: currentIndex,
//         children:tabBodies,        
//       ),
//     );
//   }
//   _check(index){
//     setState(() {
//       currentIndex = index;
//       currentPage = tabBodies[currentIndex];
//     });
//   }
// }
