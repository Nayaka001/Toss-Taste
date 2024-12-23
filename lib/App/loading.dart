import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/users_service.dart';

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading>{
  void _loadUserInfo() async{
    String token =  await getToken();
    if(token == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route)=>false);
    }
    else{
      ApiResponse response = await getUsersDetail();
      if(response.error == null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route)=>false);
      }
      else if(response.error == unauthorized){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route)=>false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}