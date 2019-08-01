import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo_model.dart';

class CartProvide with ChangeNotifier{
  String cartString = '[]';
  List<CartInfoModel> cartList=[];
  double  allPrice = 0;
  int allCount = 0;
  bool allIsCheck=true;

  save(goodsId,goodsName,count,price,images) async{
    // 初始化shared_preferences
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    cartString = prefs.get('cartInfo');//获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString);
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    int ival=0; //用于进行循环的索引使用
    bool isHave=false;
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        item['count']++;
        cartList[ival].count++;
        isHave=true;
      }
        ival++;
    });
    if(!isHave){
        Map<String, dynamic> newGoods={
            'goodsId':goodsId,
            'goodsName':goodsName,
            'count':count,
            'price':price,
            'images':images,
            'isCheck':true,
          };
          tempList.add(newGoods);
          cartList.add(CartInfoModel.fromJson(newGoods));
          isHave=false;
      }
       //把字符串进行encode操作，
        cartString = json.encode(tempList).toString();
        print(cartString);
        prefs.setString('cartInfo', cartString);
        await getCartInfo();
        notifyListeners();
  }
  // clear
  remove() async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList=[];
    notifyListeners();
  }
  //得到购物车中的商品
  getCartInfo() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     //获得购物车中的商品,这时候是一个字符串
     cartString=prefs.getString('cartInfo'); 
     //把cartList进行初始化，防止数据混乱 
     cartList=[];
     allPrice=0;
     allCount=0;
     allIsCheck=true;
     //判断得到的字符串是否有值，如果不判断会报错
     if(cartString==null){
       cartList=[];
     }else{
       List<Map> tempList= (json.decode(cartString.toString()) as List).cast();
       tempList.forEach((item){
         if(item['isCheck']){
           allPrice+=(item['count']*item['price']);
           
           allCount+=item['count'];
         }else{
           allIsCheck=false;
         }
          cartList.add(new CartInfoModel.fromJson(item));
       });
     }
      notifyListeners();
  }
  // 删除单个商品
  delateCartList(String goodsId) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //获得购物车中的商品,这时候是一个字符串
      cartString=prefs.getString('cartInfo'); 
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

      var tempIndex=0;
      var deIndex=0;
      tempList.forEach((item){
        if(item['goodsId'] == goodsId){
          deIndex = tempIndex;
        }
        tempIndex++;
      }); 

      tempList.removeAt(deIndex);
      cartString = json.encode(tempList).toString();
      prefs.setString('cartInfo', cartString);
      await getCartInfo();
  }
  // 单选 
  changeCheckState(CartInfoModel critem) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //获得购物车中的商品,这时候是一个字符串
      cartString=prefs.getString('cartInfo'); 
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      var tempIndex=0;
      var deIndex=0;
      tempList.forEach((item){
        if(item['goodsId']==critem.goodsId){
          deIndex=tempIndex;
        }
        tempIndex++;
      });
      tempList[deIndex]=critem.toJson();
      cartString = json.encode(tempList).toString();
      prefs.setString('cartInfo', cartString);
      await getCartInfo();
  }
  // 全选
  allCheck(bool val) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      //获得购物车中的商品,这时候是一个字符串
    cartString=prefs.getString('cartInfo'); 
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList=[];
    if(tempList.length>0){
      tempList.forEach((item){
        var newitem = item;
        newitem['isCheck']=val; //改变选中状态
        newList.add(newitem);
      });
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
  // 增加 减少
  addOrReduceAction(var  critem,String ado) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      //获得购物车中的商品,这时候是一个字符串
    cartString=prefs.getString('cartInfo'); 
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    var tempIndex=0;
    var deIndex=0;
    tempList.forEach((item){
      if(item['goodsId']==critem.goodsId){
        deIndex=tempIndex;
      }
      tempIndex++;
    });
    if(ado=='add'){
      critem.count++;
    }else if(critem.count>1){
      critem.count--;
    }
    tempList[deIndex]=critem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}
