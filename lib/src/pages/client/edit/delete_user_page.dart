import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:uber/src/pages/administration/menu/menu_admin_controller.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/pages/client/edit/client_edit_page.dart';
import 'package:uber/src/pages/home/home_page.dart';
import 'package:uber/src/widgets/button_app.dart';
class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

    }
    );
    print('_____________________________ID CLIENTE_________________________'+ _auth.currentUser.uid);

  }

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: _onBackPressed,
        child:
        Scaffold(
        key: key,
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  _bannerApp(),
                  _ButtonEditar(),
                  _ButtonDelete(),




                ])
        )
    ));
  }
  Future<bool> _onBackPressed() async {
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
    // Your back press code here...
    // displaySnackBar("--");
  }
  Widget _ButtonEditar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: SlideAction(
        height: 60,

        onSubmit: (){      Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => ClientEditPage()));},
        text: 'Editar Perfil',

        outerColor: Colors.black, 
        innerColor: Colors.white,
      ),
    );
  }

  Widget _ButtonDelete() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: SlideAction(
        reversed: true,
        onSubmit: () =>  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
      title: const Text('ADVERTENCIA'),
      content: const Text('¿Decea eliminar la cuenta?'),
      actions: <Widget>[
      TextButton(
      onPressed: () => {


      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) => DeleteUserPage()))

        },
      child: const Text('Cancelar'),
      ),
      TextButton(
      onPressed: () async =>  {
      await FirebaseFirestore.instance.collection("Clients").doc(_auth.currentUser.uid).delete().whenComplete(
      () {
      print('=======================ACHIVO ELIMINADO===================');
          signOut();
      },
      )

      },
    child: const Text('Aceptar'),
    ),
    ],
    ),
        ),
        height: 60,
        text: 'Eliminar Cuenta',
        innerColor: Colors.red,
        sliderButtonIcon: Icon(Icons.error, color: Colors.white,),
        outerColor: Colors.black,
      ),
    );
  }
  void signOut() async {

    //redirect
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePages())));

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
