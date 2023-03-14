import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/utils/otp_widget.dart';

import 'package:uber/src/widgets/button_app.dart';

import 'driver_register_controller.dart';

  class DriverRegisterPage extends StatefulWidget {
  @override
  _DriverRegisterPageState createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  DriverRegisterController _con = new DriverRegisterController();
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
            _textLicenceState(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: OTPFields(
                  pin1: _con.pin1Controller,
                pin2: _con.pin2Controller,
                pin3: _con.pin3Controller,
                pin4: _con.pin4Controller,
                pin5: _con.pin5Controller,
                pin6: _con.pin6Controller,
                pin7: _con.pin7Controller
              ),
            ),
            _textFieldUsername(),
            _textFieldCellNumber(),
            _textFieldColorymodelo(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _ButtonRegister()

          ],

        ),
      ),
    );
  }

  Widget _textLicenceState(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Placa del Vehiculo',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 17
        ),
      ),
    );
  }

  Widget _textFieldCellNumber(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.Cellnumber,
        decoration: InputDecoration(
            hintText: '639*******',
            labelText: 'Numero de telefono',
            suffixIcon: Icon(
              Icons.phone,
              color: utils.Colors.uberColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldColorymodelo(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.Colorymodelo,
        decoration: InputDecoration(
            hintText: 'Nissan - Gris',
            labelText: 'Modelo y Color',
            suffixIcon: Icon(
              Icons.directions_car_rounded,
              color: utils.Colors.uberColor,
            )
        ),
      ),
    );
  }



  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
        "Registro Conductor",
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
