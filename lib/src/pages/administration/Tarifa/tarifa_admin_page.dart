import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/utils/otp_widget.dart';

import 'package:uber/src/widgets/button_app.dart';

import 'tarifa_admin_controller.dart';

  class TarifaAdminPage extends StatefulWidget {
  @override
  _TarifaAdminPageState createState() => _TarifaAdminPageState();
}

class _TarifaAdminPageState extends State<TarifaAdminPage> {
  TarifaAdminController _con = new TarifaAdminController();

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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainer("Actualizar Tarifa"),
            _textBASE(),
            _textInput(controller: _con.BaseController,hint: _con.BASEG,icon: Icons.home ,type: TextInputType.number),
            _textKM(),
            _textInput(controller: _con.KMController,hint:_con.KMG ,icon: Icons.alt_route ,type: TextInputType.number),
            _textMIN()          ,
            _textInput(controller: _con.MINController,hint: _con.MING ,icon: Icons.alarm ,type: TextInputType.number),

            _ButtonRegister()

          ],

        ),
      ),
    );
  }
  Widget _textInput({controller, hint, icon, type}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[900]
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(color: Colors.white),
        cursorColor: blackColors,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }

  Widget _ButtonRegister(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonWidget(
        btnText: "Registrar Ahora",
        onClick: _con.register,
      ),
    );
  }



  Widget _textBASE(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "BASE",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }
  Widget _textMIN(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "MIN",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }
  Widget _textKM(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "KM",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }



  void refresh() {
    setState(() {});
  }
}
