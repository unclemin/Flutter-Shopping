import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/details.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfor = null;
   bool isLeft = true;
   bool isRight = false;
  //改变tabBar的状态
  changeLeftAndRight(String changeState){
    if(changeState=='left'){
      isLeft=true;
      isRight=false;
    }else{
      isLeft=false;
      isRight=true;
    }
     notifyListeners();
  }
  //从后台获取商品数据
  getGoodsInfo(String id) async{
    print(id);
    var formData={
      'goodId':id,
    };
  await request('getGoodDetailById', formData:formData).then((res){
      var resData = json.decode(res.toString());
      // print(resData);
      goodsInfor = DetailsModel.fromJson(resData);
      notifyListeners();
    });
  }

}