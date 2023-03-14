
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber/src/pages/administration/img/img_controller.dart';

class ImgPage extends StatefulWidget {
  @override
  _ImgPageState createState() => _ImgPageState();
}

class _ImgPageState extends State<ImgPage> {
  ImgController _con = ImgController();
  @override
  void initState() {
    // TODO: implement initState
    _con.init(context, refresh);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  WillPopScope(
        key: _con.key,
        onWillPop: _onBackPressed,
        child: GestureDetector(
          onTap: _con.showAlertDialog,
          child: Image( image:  _con.imageFile != null ?
          AssetImage(_con.imageFile?.path ?? 'assets/img/logo.png') :
          _con.code?.image != null
              ? NetworkImage(_con.code?.image)
              : AssetImage(_con.imageFile?.path ?? 'assets/img/logo.png'),
          ),
        ),);
  }
  Future<bool> _onBackPressed() async {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('ADVERTENCIA'),
          content: const Text('¿Decea guardar la imagen?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                Navigator.pushNamed(context, 'Menu')
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async =>  {
               _con.update(),
                Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false)
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  void refresh() {
    setState(() {

    });
  }


}