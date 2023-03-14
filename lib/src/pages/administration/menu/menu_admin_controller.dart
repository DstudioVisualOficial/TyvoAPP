
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/src/pages/client/pagesClient/splash_page.dart';
import 'package:uber/src/pages/home/home_page.dart';
import 'package:uber/src/utils/shared_pref.dart';
class MenuAdminController {
  SharedPref _sharedPref;

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future init(BuildContext context)async{
    _sharedPref = new SharedPref();
    saveTypeUser('admin');
    this.context = context;
  }
  void regConductor(){

    Navigator.pushNamed(context, "RegisterDriver");
  }
  void regCode(){
    Navigator.pushNamed(context, "register/code");
  }
  void regImage(){
    Navigator.pushNamed(context, "image");
  }
  void delConductor(){
    Navigator.pushNamed(context, "admin/list/driver");
  }
  void delAdministrador(){
    Navigator.pushNamed(context, "admin/list/admin");
  }
  void regCupon(){
    Navigator.pushNamed(context, "admin/register/cupon");
  }
  void regAdmin(){

    Navigator.pushNamed(context, "RegisterAdmin");
  }
  void regTarifa(){


    Navigator.pushNamed(context, "Tarifa");
  }

  void signOut() async {
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SplashPage())));
  }
  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
  }
  }
