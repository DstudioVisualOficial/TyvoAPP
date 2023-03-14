import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/administration/CuponsRegister/cupons_register_controller.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

class CuponsRegister extends StatefulWidget {
  @override
  _CuponsRegisterState createState() => _CuponsRegisterState();
}

class _CuponsRegisterState extends State<CuponsRegister > {
  CuponsRegisterController _con = new CuponsRegisterController();
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
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WarningWidgetChangeNotifier(),
            _bannerApp(),
            _textLogin(),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _textFieldCiudad(),
            _textFieldcode(),
            _textFieldDesc(),
            _textFieldViajes(),
            _textFielddias(),

            _ButtonLogin(),
          ],

        ),
      ),
    );
  }

  Widget _textFieldCiudad(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.ciudadController,
        style: TextStyle(color:Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
            hintText: 'GLOBAL',
            labelStyle:TextStyle(color:Colors.white),
            hintStyle: TextStyle(color:Colors.white),
            labelText: 'Ciudad:',
            suffixIcon: Icon(
              Icons.home_work,
              color: Colors.tealAccent,
            )
        ),
      ),
    );
  }

  Widget _textFieldDesc(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.descuentoController,
        style: TextStyle(color:Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
            hintText: '.25',
            hintStyle: TextStyle(color:Colors.white),
            labelStyle: TextStyle(color:Colors.white),
            labelText: 'Porcentaje de descuento:',
            suffixIcon: Icon(
              Icons.bar_chart,
              color: Colors.orange,
            )
        ),
      ),
    );
  }
  Widget _textFieldViajes(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.viajesController,
        style: TextStyle(color:Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
            hintText: '3',
            hintStyle: TextStyle(color:Colors.white),
            labelStyle: TextStyle(color:Colors.white),
            labelText: 'Total de viajes admitidos:',
            suffixIcon: Icon(
              Icons.av_timer,
              color: Colors.red,
            )
        ),
      ),
    );
  }
  Widget _textFieldcode(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.codeController,
        style: TextStyle(color:Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
            hintText: 'Tyvo',
            labelStyle: TextStyle(color:Colors.white),
            hintStyle:TextStyle(color:Colors.white),
            labelText: 'Codigo:',
            suffixIcon: Icon(
              Icons.code,
              color: Colors.indigo,
            )
        ),
      ),
    );
  }
  Widget _textFielddias(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.diasController,
        style: TextStyle(color:Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
            hintText: '2',
            labelText: 'Dias disponibles:',
            labelStyle: TextStyle(color:Colors.white),
            hintStyle: TextStyle(color:Colors.white),
            suffixIcon: Icon(
              Icons.today,
              color: Colors.purple,
            )
        ),
      ),
    );
  }
  Widget _ButtonLogin(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: SlideAction(
        onSubmit: _con.RegistrerCupon,
        text:'Registrar',
        height: 60,
        outerColor: Colors.grey[800],
        innerColor: Colors.white,
        sliderButtonIcon: Icon(Icons.sticky_note_2, color: Colors.amber,),
      ),
    );
  }





  Widget _textLogin(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "CUPONES",
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Revamped',
            fontWeight: FontWeight.bold,
            fontSize: 30
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
