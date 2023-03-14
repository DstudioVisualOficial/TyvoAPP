import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/pages/administration/menu/menu_admin_controller.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/client/verification/verificationRequest_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
class VerificationRequest extends StatefulWidget {
  @override
  _VerificationRequestState createState() => _VerificationRequestState();
}

class _VerificationRequestState extends State<VerificationRequest> {
  verificationRequestController _con = new  verificationRequestController();

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
      appBar: AppBar(
      ),
    body: SingleChildScrollView(
    child: Column(
    children: [
      _bannerApp(),
      _textsorry(),
_textsorrry(),
_ButtonSolicitar(),
      _ButtonVolverMap()
    ])
    )
    );
  }
  Widget _ButtonSolicitar(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regSolicitud,
        texto:'Solicitar nuevamente',
        color: utils.Colors.uberColor,
        textColor: Colors.white,
      ),
    );
  }
  Widget _textsorry(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: Text(
        "Lo sentimos",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      ),
    );
  }
  Widget _textsorrry(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: Text(
        "No hemos encontrado un conductor disponible",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17
        ),
      ),
    );
  }
  Widget _ButtonVolverMap(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.regCancelarSolicitud,
        texto:'Cancelar',
        color: utils.Colors.uberColor,
        textColor: Colors.white,
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      child:      Container(
        height: MediaQuery.of(context).size.height*0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 320,
              height: 210,
            ),
          ],
        ),
      ),
    );
  }
}
