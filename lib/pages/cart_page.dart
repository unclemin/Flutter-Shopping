import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart_provide.dart';
import './cart_page/cart_item_page.dart';
import './cart_page/cart_bottom.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        centerTitle: true,
      ),
      body:FutureBuilder(
        future: _getCartList(context),
        builder: (context,snapshot){
          List cartList = Provide.value<CartProvide>(context).cartList;
          if(snapshot.hasData && cartList!=null){
              return Stack(
                children: <Widget>[
                  Provide<CartProvide>(
                    builder: (context,child,childCategory){
                      cartList = Provide.value<CartProvide>(context).cartList;
                      return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context,index){
                        return CartItemPage(cartList[index]);
                      },
                     );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CartBottom(),
                  )
                ],
              );
          }else{
            return Text('lading...');
          }
        },
      )
    );
  }
  Future<String> _getCartList(BuildContext context) async{
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'ok';
  }
}


