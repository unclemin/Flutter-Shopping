import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';





Future request(url,{formData})async{
  try{
    print("start123..........");
    Response response;
    Dio dio=new Dio();
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    if(formData==null){
      response = await dio.post(servicePath[url]);
    }else{
      response = await dio.post(servicePath[url],data:formData);
    }
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======> ${e}');
  }
}

Future getHomePageCenter()async{
  try{
    print("start...");
    Response response;
    Dio dio=new Dio();
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon':'115.02932','lat':'35.76189'};
    response = await dio.post(servicePath['homePageContext'],data:formData);
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======> ${e}');
  }
}

// 火爆专区
Future hotGoods()async{
  try{
    print("开始获取下拉列表...");
    Response response;
    Dio dio=new Dio();
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    int page = 1; 
    // var formData = {'lon':'115.02932','lat':'35.76189'};
    response = await dio.post(servicePath['homePageBelowConten'],data:page);
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======> ${e}');
  }
}