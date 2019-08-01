import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_infor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,res){
        var goodsInfor = Provide.value<DetailsInfoProvide>(context).goodsInfor.data.goodInfo;
        if(goodsInfor != null){
          return  Container(
              color: Colors.white,
              width: ScreenUtil().setWidth(740),
              child: Column(
                children: <Widget>[
                  _getGoodsImage(goodsInfor.image1),
                  _getPrice(goodsInfor.oriPrice),
                  _getName(goodsInfor.goodsName),
                  _getDecrition(goodsInfor.goodsSerialNumber),
                ],
              ),
          );
        }else{
          return Center(
            child: Text('没有数据...'),
          );
        }
      }
    );
  }

  // img
  Widget _getGoodsImage(image){
    return Image.network(
      image,
      width: ScreenUtil().setWidth(740),
      height: ScreenUtil().setHeight(620),
    );
  }
  // 价格
  Widget _getPrice(price){
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 10.0,bottom: 5.0),
      child: Text(
        '市场价:￥${price}',
        style: TextStyle(fontSize: ScreenUtil().setSp(30),
        color: Colors.pink),
      ),
    );
  }
  // titile
  Widget _getName(name){
    return Container(
     width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
      child: Text(
        name,
        style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Colors.black),
      ),
    );
  }
  // decrition
  Widget _getDecrition(dis){
    return Container(
       width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
      child: Text(
        '商品编号:${dis}',
        style: TextStyle(fontSize: ScreenUtil().setSp(20),color: Colors.black12),
      ),
    );
  }
}