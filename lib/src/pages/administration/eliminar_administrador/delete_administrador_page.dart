import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

import 'delete_administrador_controller.dart';

class DeleteAdminPage extends StatefulWidget {
  @override
  _DeleteAdminPageState createState() => _DeleteAdminPageState();
}

class _DeleteAdminPageState extends State<DeleteAdminPage > {
  DeleteAdminController _con = new DeleteAdminController();
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
            _text(),
            _textuser(),
            _ButtonDelete(),
          ],

        ),
      ),
    );
  }

  Widget _ButtonDelete(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: SlideAction(
        height: 60,
        onSubmit: _con.EliminarConductor,
        text:'Eliminar',
        outerColor: Colors.grey[800],
        innerColor: Colors.white,
        sliderButtonIcon: Icon(Icons.delete_forever, color: Colors.red,),
      ),
    );
  }





  Widget _text(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        "ELIMINAR ADMINISTRADOR",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28
        ),
      ),
    );
  }

  Widget _textuser(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
    "Administrador: "+_con.username.toString()??"nulo",maxLines: 1,
        style: TextStyle(

          fontFamily: "NimbusSans",
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );

  }

  Widget _bannerApp(){
    return ClipPath(
      child:      Container(
        height: MediaQuery.of(context).size.height*0.20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 300,
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
