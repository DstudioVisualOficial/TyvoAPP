import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/pages/administration/menu/menu_admin_controller.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/widgets/button_app.dart';
class MenuAdmin extends StatefulWidget {
  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  MenuAdminController _con = new  MenuAdminController();

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
      backgroundColor: Colors.black,
    body: SingleChildScrollView(
    child: Column(
    children: [
      HeaderContainer("Bienvenido Administrador"),
      _ButtonConductor(),
      _ButtonDelConductor(),
      _ButtonAdmin(),
      _ButtonTarifa(),
      _ButtonCode(),
      _ButtonCodes(),
      _ButtonImagen(),
      _ButtonCerrar()
    ])
    )
    );
  }
  Widget _ButtonCodes(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regCupon,
        texto:'Registrar Cupon',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonCode(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regCode,
        texto:'Password Secreto',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonImagen(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regImage,
        texto:'Imagen Publicitaria',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonConductor(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regConductor,
        texto:'Registrar Conductor',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonDelConductor(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.delConductor,
        texto:'Eliminar Conductor',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonTarifa(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regTarifa,
        texto:'Actualizar Tarifa',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }

  Widget _ButtonAdmin(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regAdmin,
        texto:'Registrar Administrador',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _ButtonCerrar(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.signOut,
        texto:'Salir',
        color: blackColors,
        textColor: Colors.white,
      ),
    );
  }
  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo() ,
      child:      Container(
        color: blackColors,
        height: MediaQuery.of(context).size.height*0.30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 400,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
