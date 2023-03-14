import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/register/client_register_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';
import 'driver_registercottaximetro_controller.dart';

  class DriverRegisterCotTaximetroPage extends StatefulWidget {
  @override
  _DriverRegisterCotTaximetroState createState() => _DriverRegisterCotTaximetroState();
}

class _DriverRegisterCotTaximetroState extends State<DriverRegisterCotTaximetroPage> {

  DriverRegisterCotTaximetroController _con = new DriverRegisterCotTaximetroController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
     _con.init(context);
     refresh();
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
            const WarningWidgetChangeNotifier(),
            SizedBox(height: 3,),
            _bannerApp(),
            _textLogin(),
            _textFieldUsername(),
            _textFieldClienteName(),
            _textFieldCell(),
            _textFieldPrecio(),
            Container(width: MediaQuery.of(context).size.height * 0.4,child:_textFieldComentarios(),),
            _ButtonRegisterCotizacion()

          ],

        ),
      ),
    );
  }

  Widget _textFieldClienteName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.clienteController,
        decoration: InputDecoration(
          hintText: "Nombre cliente",
              labelText: "Nombre cliente",
            suffixIcon: Icon(
              Icons.person,
              color: utils.Colors.uberColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldCell(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _con.CellController,
        decoration: InputDecoration(
            hintText: "Numero del cliente",
            labelText: "Numero de celular del cliente",
            suffixIcon: Icon(
              Icons.phone,
              color: utils.Colors.uberColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldComentarios(){
    return TextFormField(
      controller: _con.txtcomentariocontroller,
      minLines: 2,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(

          hintText: 'Comentario al cliente (Opcional)',
          hintStyle: TextStyle(
              color: Colors.grey
          ),
          border:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
          )
      ),
    );
  }



  Widget _textFieldUsername(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        enabled: false,
        decoration: InputDecoration(
            hintText: 'Usuario',
            labelText: _con.username,
            suffixIcon: Icon(
              Icons.person_outline,
              color: utils.Colors.uberColor,
            )
        ),
      ),
     );
  }



  Widget _ButtonRegisterCotizacion(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonWidget(
        onClick: _con.register,
        btnText:'Registrar Cotizacion',
      ),
    );
  }
  Widget _textFieldPrecio(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextField(
        controller: _con.precioController,
        obscureText: true,
       enabled: false,
        decoration: InputDecoration(
            hintText: _con.price.toString(),
            labelText: _con.price.toString(),
            suffixIcon: Icon(
              Icons.animation,
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
        "Registro",
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
      child:      Container(
        height: MediaQuery.of(context).size.height*0.20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
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
