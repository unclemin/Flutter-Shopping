import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import './provide/details_infor.dart';
import './provide/cart_provide.dart';
import './provide/currunt_index.dart';


import 'package:fluro/fluro.dart';
import 'routers/routes.dart';
import 'routers/application.dart';


void main(){
  var counter = Counter();
  var providers  = Providers();
  var childCategory  = ChildCategory();
  var categoryGoodsListProvide  = CategoryGoodsListProvide();
  var detailsInfoProvide  = DetailsInfoProvide();
  var cartProvide  = CartProvide();
  var curruntProvide  = CurruntProvide();



  final router = Router();
  Routes.configureRoutes(router);
  Application.router=router;

  providers
  ..provide(Provider<Counter>.value(counter))
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
  ..provide(Provider<CartProvide>.value(cartProvide))
  ..provide(Provider<CurruntProvide>.value(curruntProvide))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
  runApp(ProviderNode(child:MyApp(),providers:providers));
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "百姓生活+实战",
        debugShowCheckedModeBanner: false,//取消debug
        onGenerateRoute: Application.router.generator,
        // 主题颜色
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),//入口页面
      ),
    );
  }
}