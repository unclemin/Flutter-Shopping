import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/details_infor.dart';
import 'package:flutter_html/flutter_html.dart';

class DtailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail=Provide.value<DetailsInfoProvide>(context).goodsInfor.data.goodInfo.goodsDetail;
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if(isLeft){
          return Container(
            padding:EdgeInsets.only(bottom:44.0),
            child: Html(
              data:goodsDetail ,
              // data: """
              //   <div>
              //     <h1>Demo Page</h1>
              //     <p>This is a fantastic nonexistent product that you should buy!</p>
              //     <h2>Pricing</h2>
              //     <p>Lorem ipsum <b>dolor</b> sit amet.</p>
              //     <h2>The Team</h2>
              //     <p>There isn't <i>really</i> a team...</p>
              //     <h2>Installation</h2>
              //     <p>You <u>cannot</u> install a nonexistent product!</p>
              //     <!--You can pretty much put any html in here!-->
              //   </div>
              // """,
            )
          );
        }else{
          return  Container(
            child: Text('no more'),
          );
          
        }
      },
    );
  }
}