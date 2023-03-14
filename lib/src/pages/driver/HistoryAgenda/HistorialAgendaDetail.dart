import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/administration/login_controller_admin.dart';
import 'package:uber/src/pages/driver/HistoryAgenda/HistorialAgendaDetailController.dart';
import 'package:uber/src/pages/login/login_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

class HistorialAgendaDetail extends StatefulWidget {
  @override
  _HistorialAgendaDetailState createState() => _HistorialAgendaDetailState();
}

class _HistorialAgendaDetailState extends State<HistorialAgendaDetail > {
  HistorialAgendaDetailController _con = new HistorialAgendaDetailController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    _con.init(context, refresh);
    refresh();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,),
      key: _con.key,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WarningWidgetChangeNotifier(),
            _bannerApp(),
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            _txttexto('FECHA'),
            _txtfield(_con.fecha?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('STATUS'),
            _txtfield(_con.status?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('KM'),
            _txtfield(_con.km?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('MIN'),
            _txtfield(_con.min?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('INICIO'),
            _txtfield(_con.from ?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('LLEGADA'),
            _txtfield(_con.to ?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('CLIENTE'),
            _txtfield(_con.nameClient ?? 'Sin datos'),
           /* SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttimestampdesc(),
            _txttimestamp(),*/
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('PRECIO'),
            _txtfield(_con.price ?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('CONDUCTOR'),
            _txtfield(_con.nameDriver ?? 'Sin datos'),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            _txttexto('COMENTARIO'),
            _txtfield(_con.comentario?? 'Sin datos'),
          ],

        ),
      ),
    );
  }
Widget _txttexto(String texto){
  return Container(
    alignment: Alignment.centerLeft,
    margin: EdgeInsets.symmetric(horizontal: 30),
    child: Text(
    texto,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15
      ),
    ),
  );
}
  Widget _txtfield(String controller){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        controller??" ",maxLines: 1,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15
        ),
      ),
    );
  }
  Widget _bannerApp(){
    return ClipPath(
      child:      Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height*0.18,
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


