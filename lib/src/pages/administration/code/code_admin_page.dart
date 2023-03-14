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

import 'code_admin_controller.dart';

  class CodeAdminPage extends StatefulWidget {
  @override
  _CodeAdminPageState createState() => _CodeAdminPageState();
}

class _CodeAdminPageState extends State<CodeAdminPage> {
  CodeAdminController _con = new CodeAdminController();

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
            HeaderContainer(""),
            _textBASE(),
            _textInput(controller: _con.userController,hint: _con.user,icon: Icons.verified_user ,type: TextInputType.text),
            _textpassword(),
            _textInput(controller: _con.passwordController,hint:_con.password ,icon: Icons.lock_outlined ,type: TextInputType.text),
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
        color: whiteColors,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.red,
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
        btnText: "Actualizar",
        onClick: _con.register,
      ),
    );
  }



  Widget _textBASE(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "User",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }
  Widget _textpassword(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        "Password",
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
