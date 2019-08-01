import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList  = [];
  int childIndex = 0;//子类高亮索引
  String categoryId = '4';//大类id
  String subId = '';//小类id
  int page = 1;//列表页数
  String noMoreText = '';//显示更多


  //大类切换逻辑
  getChildCategory(List<BxMallSubDto> list,id){
    page = 1;
    noMoreText='';
    childIndex=0;
    subId='';
    categoryId=id;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId='';
    all.mallCategoryId='00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList=[all];
    childCategoryList.addAll(list);
    notifyListeners();
    print(page);

  }
  //索引切换逻辑
  changeChildIndex(index,id){
    childIndex=index;
    subId = id;
    page = 1;
    noMoreText = '';
    print(page);
    notifyListeners();
  }
  // 页码加1
  addPage(){
    page++;
    print(page);
  }
  // 显示更多文字改变
  changenoMoreText(String text){
    noMoreText = text;
    notifyListeners();
  }
}