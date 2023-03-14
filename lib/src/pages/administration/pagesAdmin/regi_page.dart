import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/pages/administration/driver_register_controller_admin.dart';
import 'package:uber/src/pages/administration/driver_register_page_admin.dart';


class RegPageAdmin extends StatefulWidget {
  @override
  _RegPageAdminState createState() => _RegPageAdminState();
}

class _RegPageAdminState extends State<RegPageAdmin> {
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainer("Registrar Administrador"),
            _textInput(controller: _con.usernameController,hint: "Nombre Completo", icon: Icons.person,type: TextInputType.text ),
                    _textInput(controller: _con.emailController, hint: "Correo", icon: Icons.email, type: TextInputType.emailAddress),
                    //_textInput(hint: "Phone Number", icon: Icons.call),
                    _textInput(controller: _con.passwordController, hint: "Contraseña", icon: Icons.vpn_key, type: TextInputType.visiblePassword),
                    _textInput(controller: _con.confirmpasswordController, hint: "Confirmar contraseña", icon: Icons.vpn_key, type: TextInputType.visiblePassword),
                    _ButtonRegister(),
                  ],
                ),
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
  Widget _textInput({controller, hint, icon,type}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        cursorColor: blackColors,
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

}
