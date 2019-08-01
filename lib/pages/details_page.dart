import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_infor.dart';
import '../pages/details_page/details_top_area.dart';
import '../pages/details_page/details_explain.dart';
import '../pages/details_page/details_tabbar.dart';
import '../pages/details_page/detals_web.dart';
import '../pages/details_page/details_bottom.dart';
import '../provide/cart_provide.dart';



class DetailsPage  extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    _getGoodsList(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:FlexibleSpaceBar(
          title: Text('商品详情页'),
          centerTitle:true,
         )
        ),
      body: FutureBuilder(
        future:_getGoodsList(context),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    DetailsArea(),//顶部图片。标题
                    DetailsExplain(),//说明
                    DetailsTabBar(),//tabbar
                    DtailsWeb(),//web
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
                )
              ],
            );
          }else{
            return Text('lading......');
          }
        },
      ),
    );
  }
  Future _getGoodsList(BuildContext context) async{
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}