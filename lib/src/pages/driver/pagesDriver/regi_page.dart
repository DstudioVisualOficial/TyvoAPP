import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';

import 'package:uber/src/pages/driver/register/driver_register_controller.dart';
import 'package:uber/src/utils/otp_widget.dart';


class RegPageDriver extends StatefulWidget {
  @override
  _RegPageDriverState createState() => _RegPageDriverState();
}

class _RegPageDriverState extends State<RegPageDriver> {
  DriverRegisterController _con = new DriverRegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT STATE');

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
                   HeaderContainer("Registrar Conductor"),
                    _TextPlate(),
                    _textInput(controller: _con.usernameController,hint: "Nombre Completo", icon: Icons.person),
                    _textInput(controller: _con.Colorymodelo ,hint: "Color y modelo", icon: Icons.add_chart),
                    _textInput(controller: _con.Cellnumber,hint: "Numero de celular", icon: Icons.call),
                    _textInput(controller: _con.emailController ,hint: "Correo Electronico", icon: Icons.email),
                    _textInput(controller: _con.passwordController,hint: "Contraseña", icon: Icons.vpn_key),
                    _textInput(controller: _con.confirmpasswordController,hint: "Confirmar Contraseña", icon: Icons.vpn_key),
                    _ButtonRegister()
                  ],
                ),
              ),);
  }
  Widget _TextPlate(){

    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: OTPFields(
        pin1: _con.pin1Controller,
        pin2: _con.pin2Controller,
        pin3: _con.pin3Controller,
        pin4: _con.pin4Controller,
        pin5: _con.pin5Controller,
        pin6: _con.pin6Controller,
        pin7: _con.pin7Controller,
      ),
    );
  }
  Widget _ButtonRegister(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Center(
          child: ButtonWidget(
            btnText: "Registrar",
            onClick: (){
              _con.register();
            },
          ),
        ),

    );
  }
  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }
  void refresh() {
    setState(() {

    });
  }
}
