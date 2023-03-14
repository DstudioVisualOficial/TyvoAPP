import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/utils/otp_widget.dart';

import 'package:uber/src/widgets/button_app.dart';

import 'driver_register_controller_admin.dart';

  class DriverRegisterPageAdmin extends StatefulWidget {
  @override
  _DriverRegisterPageAdminState createState() => _DriverRegisterPageAdminState();
}

class _DriverRegisterPageAdminState extends State<DriverRegisterPageAdmin> {
  DriverRegisterControllerAdmin _con = new DriverRegisterControllerAdmin();
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
            _textLogin(),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _ButtonRegister()

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
        keyboardType: TextInputType.emailAddress,
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



  Widget _textFieldUsername(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'Usuario',
            labelText: 'Nombre de usuario',
            suffixIcon: Icon(
              Icons.person_outline,
              color: utils.Colors.uberColor,
            )
        ),
      ),
     );
  }



  Widget _ButtonRegister(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        texto:'Registrar ahora',
        color: utils.Colors.uberColor,
        textColor: Colors.white,
      ),
    );
  }
  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: _con.confirmpasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: '******',
            labelText: 'Confirmar Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_sharp,
              color: utils.Colors.uberColor,
            )
        ),
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
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "Registro Administrador",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 25
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
            ),
            Text(
              "Facil y Rapido",
              style: TextStyle(
                color: Colors.white,
                  fontFamily: 'Pacifico',
                  fontSize: 22,
                  fontWeight: FontWeight.w600 //Letras en negritas
              ),
            )
          ],
        ),
      ),
    );
  }
}
