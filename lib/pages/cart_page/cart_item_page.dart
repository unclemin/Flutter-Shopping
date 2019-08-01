import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/cartInfo_model.dart';
import 'cart_count.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';

class CartItemPage extends StatelessWidget {
  final CartInfoModel item;
  CartItemPage(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0,2.0,5.0,2.0),
      padding: EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0,color: Colors.black12),
        )
      ),
      child: Row(
        children: <Widget>[
          _checkBox(context,item),
          _image(item),
          _name(item),
          _price(context,item)
        ],
      ),
    );
  }

  //checkbox
  Widget _checkBox(context,item){
    return Container(
      child: Checkbox(
        value: item.isCheck,
        activeColor: Colors.pink,
        onChanged: (bool val){
          item.isCheck=val;
          Provide.value<CartProvide>(context).changeCheckState(item);
        },
      ),
    );
  }
  // img
  Widget _image(item){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      child: Image.network(item.images),
    );
  }
  // name
  Widget _name(item){
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child:Text(item.goodsName),
          ),
          CartCount(item),
        ],
      ),
    );
  }
  // price
  Widget _price(context,item){
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}'),
          Container(
            child: InkWell(
              onTap: (){
                Provide.value<CartProvide>(context).delateCartList(item.goodsId);
              },
              child: Icon(
              Icons.delete,
              color: Colors.black12,
              size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}