import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'login_page.dart';
import 'package:uber/src/utils/shared_pref.dart';

import 'package:uber/src/pages/client/pagesClient/splash_page.dart';

class SplashPageAdmin extends StatefulWidget {
  @override
  _SplashPageAdminState createState() => _SplashPageAdminState();
}

class _SplashPageAdminState extends State<SplashPageAdmin> {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  SharedPref _sharedPref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPref = new SharedPref();

    Timer(const Duration(milliseconds: 4000), () {
      saveNotification("false");
      saveTypeUser("admin");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPageAdmin()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: key,
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
  Future<bool> _onBackPressed() async {

    await  utils.Snackbar.showSnacbar(context, key, "Cargando...");
    // Your back press code here...
    // displaySnackBar("--");
  }
  void saveNotification(String typeUser)async{
    _sharedPref.remove('isNotification');
    _sharedPref.save("isNotification", typeUser);
  }
  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
  }
}
