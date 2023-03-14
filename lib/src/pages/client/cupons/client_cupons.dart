import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/administration/CuponsRegister/cupons_register_controller.dart';
import 'package:uber/src/pages/administration/login_controller_admin.dart';
import 'package:uber/src/pages/client/cupons/client_cupons_controller.dart';
import 'package:uber/src/pages/login/login_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

class ClientCupons extends StatefulWidget {
  @override
  _ClientCuponsState createState() => _ClientCuponsState();
}

class _ClientCuponsState extends State<ClientCupons> {
  ClientCuponsController _con = new ClientCuponsController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
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
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _textFieldcode(),

            _ButtonLogin(),
            const WarningWidgetChangeNotifier(),
          ],

        ),
      ),
    );
  }

  Widget _textFieldcode(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.cuponController,
        decoration: InputDecoration(
            hintText: '******',
            labelText: 'Codigo:',
            suffixIcon: Icon(
              Icons.code,
              color: Colors.indigo,
            )
        ),
      ),
    );
  }
  Widget _ButtonLogin(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.checkcupon,
        texto:'Ingresar',
        color: Colors.black,
        textColor: Colors.white,
      ),
    );
  }





  Widget _textLogin(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Ingresa tu cupon",
        style: TextStyle(
            color: Colors.black,
            //fontFamily: 'Revamped',
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      child:      Container(
        height: MediaQuery.of(context).size.height*0.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
  void refresh() {
    setState(() {});
  }
}