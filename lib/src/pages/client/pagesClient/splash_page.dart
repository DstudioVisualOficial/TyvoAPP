import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/home/home_controller.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/pages/client/loginClient/login_client.dart';
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  HomeController _con = new HomeController();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  SharedPref _sharedPref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    _sharedPref = new SharedPref();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        key: _con.key,
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image:  _con.imageFile != null ?
              AssetImage(_con.imageFile?.path ?? 'assets/img/logo.png') :
              _con.code?.image != null
                  ? NetworkImage(_con.code?.image)
                  : AssetImage(_con.imageFile?.path ?? 'assets/img/logo.png'),
                /*  gradient: LinearGradient(
              colors: [blackColors, blackColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),*/
              ),),
          ),
        ));
  }
  void refresh() {
    setState(() {

    });
  }
  Future<bool> _onBackPressed() async {

    await  utils.Snackbar.showSnacbar(context, key, "Cargando...");
}}
