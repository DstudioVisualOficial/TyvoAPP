import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'login_page.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

class SplashPageDriver extends StatefulWidget {
  @override
  _SplashPageDriverState createState() => _SplashPageDriverState();
}

class _SplashPageDriverState extends State<SplashPageDriver> {
  SharedPref _sharedPref;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPref = new SharedPref();
    Timer(const Duration(milliseconds: 4000), () {
      saveTypeUser('driver');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPageDriver()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black,Colors.grey[700],Colors.white,Colors.grey[700], Colors.black,],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Center(
          child: Image.asset("assets/img/logo.png"),
        ),
      ),
    ));
  }
  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
  }
  Future<bool> _onBackPressed() async {

    await  utils.Snackbar.showSnacbar(context, key, "Cargando...");
  }
}
