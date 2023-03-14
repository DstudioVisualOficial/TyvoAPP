import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/administration/login_controller_admin.dart';
import 'package:uber/src/pages/login/login_controller.dart';
import 'package:uber/src/widgets/button_app.dart';

class LoginPageAdmin extends StatefulWidget {
  @override
  _LoginPageAdminState createState() => _LoginPageAdminState();
}

class _LoginPageAdminState extends State<LoginPageAdmin > {
  LoginControllerAdmin _con = new LoginControllerAdmin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
     _con.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.key,
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textDescription(),
            _textLogin(),
            SizedBox(height: MediaQuery.of(context).size.height*0.17,),
            _textFieldEmail(),
            _textFieldPassword(),
            _ButtonLogin(),
          ],

        ),
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        style:  TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Correo@gmail.com',
              labelText: 'Correo Electronico',
            labelStyle:  TextStyle(color: Colors.white),
            hintStyle:  TextStyle(color: Colors.white),
            suffixIcon: Icon(
              Icons.email_outlined,
              color: Colors.white
            )
        ),
      ),
    );
  }


  Widget _ButtonLogin(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.login,
        texto:'Iniciar sesion',
        color: utils.Colors.uberColor,
        textColor: Colors.white,
      ),
    );
  }



  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        style:  TextStyle(color: Colors.white),
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white),
            hintText: '******',
            labelText: 'Contraseña',
            labelStyle:  TextStyle(color: Colors.white),
            suffixIcon: Icon(
              Icons.lock_open_sharp,
              color: Colors.white,
            )
        ),
      ),
    );
  }

  Widget _textLogin(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "Login",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28
        ),
      ),
    );
  }

  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
          "Continua con tu",
        style: TextStyle(
          fontFamily: "NimbusSans",
          color: Colors.black,
          fontSize: 24,
        ),
      ),
    );
  }
  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo() ,
      child:      Container(
        color: utils.Colors.uberColor,
        height: MediaQuery.of(context).size.height*0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 300,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
