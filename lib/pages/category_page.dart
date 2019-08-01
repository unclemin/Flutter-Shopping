import 'dart:convert';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';//屏幕适配
import '../provide/child_category.dart';
import 'package:provide/provide.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类'),),
      body: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Column(
            children: <Widget>[
              RightCategoryNav(),
              CategoryGoodsList()
            ],
          )
        ],
      ),
    );
  }
  
}
// 左侧列表
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var childIndex = 0;
  @override
  void initState() {
    _getlist();
    _getGoodList();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1,color:Colors.black12)
          )
        ),
        child: ListView.builder(
          itemCount:list.length,
          itemBuilder: (context,index){
            return _leftInkWel(index);
          },
        ),
    );
  }
  Widget _leftInkWel(int index){
    return InkWell(
      onTap: (){
        setState(() {
          childIndex = index;
        });
        var childList= list[index].bxMallSubDto;
        var categoryId= list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
        _getGoodList(categoryId:categoryId);
      },
      child: Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(100),
        padding:EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        decoration: BoxDecoration(
          color:(childIndex==index) ? Colors.black12 : Colors.white,
          border:Border(
            bottom:BorderSide(width: 1,color:Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName,style: TextStyle(fontSize:ScreenUtil().setSp(28),color:(childIndex==index) ? Colors.pink : Colors.black,),),
      ),
    );
  }
  void _getlist() async{
    await request('getCategory').then((res){
      var data = json.decode(res.toString());
      CategoryBigModel catelist = CategoryBigModel.fromJson(data);
      setState(() {
       list = catelist.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto,list[0].mallCategoryId);
    });
  }
  void _getGoodList({String categoryId}) async{
    var data = {
      'categoryId':categoryId == null ? '4' : categoryId,
      'categorySubId':"",
      'page':1,
    };
    await request('getMallGoods',formData: data).then((res){
      var data = json.decode(res.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

// 右侧
class RightCategoryNav extends StatefulWidget {
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List lists=['13132','153534','11','23',];
  var childCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Provide<ChildCategory>(
        builder: (context,child,childCategory){
          return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1,color: Colors.black12),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:childCategory.childCategoryList.length ,
              itemBuilder: (context,index){
                return _rightinkwell(childCategory.childCategoryList[index],index);
              },
            ),
          );
        },
      )

    );
  }
  Widget _rightinkwell(BxMallSubDto item,index){
    bool isCheck = false;
    isCheck = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;
    return InkWell(
      onTap: (){
          Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
          _getGoodList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28),color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }
   void _getGoodList(String categorySubId){
    var data = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1,
    };
    request('getMallGoods',formData: data).then((res){
      var data = json.decode(res.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }
}
// 商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scrollController=new ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
      try{
        if(Provide.value<ChildCategory>(context).page == 1){
            scrollController.jumpTo(0.0);
          }
      }catch(e){
        print('进入页面第一次初始化：${e}');
      }
        if(data.goodsList.length>0){
          return  Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570) ,
              child:EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key:_footerKey,
                  bgColor:Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  noMoreText: '',
                  loadReadyText:'上拉加载....',
                  loadingText:'加载中...',
                  // loadedText:'加载完成',
                  loadText:'上拉加载',
                  showMore:true,
                ),
                child:ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _listWidget(data.goodsList,index);
                },
              ),
              loadMore: () async{
                 _getMoreList();
              },
              )
              
            ),
          );
        }else{
          return Center(
            child:Text('暂时没有数据'),
          );
        }
      },
    );
   
  }
  // 商品列表
  Widget _listWidget(List newlist,int index){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context,'/detail?id=${newlist[index].goodsId}');
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newlist,index),
            Column(
              children: <Widget>[
                _goodsName(newlist,index),
                _goodsPrice(newlist,index)
              ],
            )
          ],
        ),
      ),
    );
  }
  // 图片
  Widget _goodsImage(List newlist,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newlist[index].image),
    );
  }
  // 标题
  Widget _goodsName(List newlist,index){
    return Container(
      width: ScreenUtil().setWidth(370),
      padding: EdgeInsets.all(5.0),
      child: Text(
        newlist[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }
  // 价格
  Widget _goodsPrice(List newlist,index){
    return Container(
      width: ScreenUtil().setWidth(370),
      padding: EdgeInsets.only(top:20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
             '价格:￥${newlist[index].presentPrice}',
              style: TextStyle(color:Colors.pink,fontSize:ScreenUtil().setSp(30)),
          ),
          Text(
             '￥${newlist[index].oriPrice}',
              style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough
              )
          ),
        ],
      ),
    );
  }
  void _getMoreList(){
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page,
    };
    request('getMallGoods',formData: data).then((res){
      var data = json.decode(res.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Fluttertoast.showToast(
          msg: "没有更多数据了哟!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 14.0
       );
        Provide.value<ChildCategory>(context).changenoMoreText('亲，没有更多数据了额');
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreGoodsList(goodsList.data);
      }
    });
  }
}
