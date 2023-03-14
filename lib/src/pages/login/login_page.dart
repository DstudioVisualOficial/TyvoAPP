import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/login/login_controller.dart';
import 'package:uber/src/widgets/button_app.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _con = new LoginController();
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
            _textDontHaveAccount()
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
        decoration: InputDecoration(
          hintText: 'Correo@gmail.com',
              labelText: 'Correo Electronico',
            suffixIcon: Icon(
              Icons.email_outlined,
              color: utils.Colors.uberColor,
            )
        ),
      ),
    );
  }

  Widget _textDontHaveAccount(){
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          '¿No tienes cuenta?',
          style: TextStyle(
            fontSize: 15,
            color: utils.Colors.uberColor
          ),
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
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: '******',
            labelText: 'Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_sharp,
              color: utils.Colors.uberColor,
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
