import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert'; //json
import 'package:flutter_screenutil/flutter_screenutil.dart';//屏幕适配
import 'package:url_launcher/url_launcher.dart';//拨打电话
import 'package:flutter_easyrefresh/easy_refresh.dart';//下拉刷新
import '../routers/application.dart';
class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  int page = 1;
  List<Map> hotGoodsList=[];
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
   //重写keepAlive 为ture ，就是可以有记忆功能了。
  @override

  bool get wantKeepAlive => true;
  @override
  void initState() {
    // gethotGoods();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("百姓生活+"),),
        body: FutureBuilder(
          future: getHomePageCenter(),
          builder: (context , snapshot){
            if(snapshot.hasData){
              var data=json.decode(snapshot.data.toString());
              List<Map> swiperDataList = (data['data']['slides'] as List).cast();//swiper
              List<Map> navgetList = (data['data']['category'] as List).cast();//banner
              String bannerImge = (data['data']['advertesPicture']['PICTURE_ADDRESS']);//img
              String imgPhone = (data['data']['shopInfo']['leaderImage']);//img
              List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐

              return EasyRefresh(
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
                child:ListView(
                  children: <Widget>[
                    Swipers (swiperDataList:swiperDataList),
                    TopNav (navgetList:navgetList),
                    Banner (bannerImge:bannerImge),
                    LeaderPhone (imgPhone:imgPhone),
                    ShopList (recommendList:recommendList),
                    _hotGoods(),
                   ],
                ),
                loadMore:()async{
                  print('开始加载');
                  var formPage={'page': page};
                  await request('homePageBelowConten',formData: formPage).then((res){
                    var data = json.decode(res.toString());
                    List<Map> nesGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(nesGoodsList);
                      page ++;
                    });
                  });
                },
              );
            }else{
              return Center(
                child: Text('加载中...'),
              );
            }
          },
        )
    );
  }
  // 火爆专区获取数据方法
  // void gethotGoods(){
  //   var formPage={'page': page};
  //   request('homePageBelowConten',formData: formPage).then((res){
  //     var data = json.decode(res.toString());
  //     List<Map> nesGoodsList = (data['data'] as List).cast();
  //     hotGoodsList.addAll(nesGoodsList);
  //     page++;
  //   });
  // }
  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border:Border(
        bottom: BorderSide(width:0.5 ,color:Colors.black12)
      )
    ),
    child: Text('火爆专区',style: TextStyle(color: Colors.pink)),
  );
  // 火爆专区内容区域
  Widget _wrapList(){
    if(hotGoodsList.length!=0){
      List<Widget> listWiget = hotGoodsList.map((res){
        return InkWell(
        onTap: (){
          Application.router.navigateTo(context,"/detail?id=${res['goodsId']}");
        },
        child: Container(
          width: ScreenUtil().setWidth(372),
          color: Colors.white,
          padding: EdgeInsets.all(5.0),                                                                                                                                                                                                                                                                                            
          margin: EdgeInsets.only(bottom: 3.0),
          child: Column(
            children: <Widget>[
              Image.network(res['image']),
              Text(
                res['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('￥${res['mallPrice']}'),
                  Text(
                      '￥${res['price']}',
                      style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),
                    )
                ],
              )
            ],
          ),
        ),  
      );
      }).toList();
      return Wrap(
        spacing: 2,
        children:listWiget,
      );
    }else{
      return Text('');  
    }
  }
  // 火爆专区组合
  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}

// swiper组件
class Swipers  extends StatelessWidget {
  final List swiperDataList;
  Swipers ({this.swiperDataList});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context,"/detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
        viewportFraction: 0.8,
        scale: 0.9,
      ),
    );
  }
}
// 导航栏
class TopNav extends StatelessWidget {
  // 接收数据
  final List navgetList;
  TopNav({Key key,this.navgetList}):super(key:key);
  @override
  Widget _gridViewItemUI(BuildContext context,item) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navgetList.length>10){
      navgetList.removeRange(10,navgetList.length);
      // navgetList.indexOf(10,navgetList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics:NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navgetList.map((item){
          return  _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告图片
class Banner extends StatelessWidget {
  final String  bannerImge;
  Banner({Key key,this.bannerImge}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(bannerImge),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String imgPhone;
  LeaderPhone({Key key,this.imgPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:InkWell(
        onTap:_launchURL,
        child: Image.network(imgPhone),
      )
    );
  }
  _launchURL() async {
  const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}


// 商品列表
class ShopList extends StatelessWidget {
  final List recommendList;
  const ShopList({Key key,this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(480),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList()
        ],
      ),
    );
  }
  // 推荐商品标题
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0,color: Colors.black12)
        )
      ),
      child:Text(
        '商品推荐',
        style:TextStyle(color:Colors.pink)
      )
    );
  }
  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(context,index);
        },
      ),
    );
  }
  Widget _item(context,index){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context,"/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(350),
        width: ScreenUtil().setWidth(250),
        // padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border(
            left: BorderSide(width:1.0,color:Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color:Colors.grey,
                fontSize:11.0,
              ),
             )
          ],
        ),
      ),
    );
  }
}

// 下拉列表 火爆专区
class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}
  int page = 1;
  List<Map> hotGoodsList=[];
class _HotGoodsState extends State<HotGoods> {
   var formPage={'page': page};
  @override
  void initState() {
    request('homePageBelowConten',formData:formPage).then((res){
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Text("132132"),
    );
  }
}