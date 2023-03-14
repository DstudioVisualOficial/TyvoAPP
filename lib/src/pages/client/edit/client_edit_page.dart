import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/homes/widgets/herder_container_edit_client.dart';
import 'package:uber/src/pages/client/edit/client_edit_controller.dart';
import 'package:uber/src/pages/client/register/client_register_controller.dart';
import 'package:uber/src/utils/app_util.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/widgets/button_app.dart';

class ClientEditPage extends StatefulWidget {
  @override
  _ClientEditPageState createState() => _ClientEditPageState();
}

class _ClientEditPageState extends State<ClientEditPage> {

  ClientEditController _con = new ClientEditController();

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

    return   WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
      key: _con.key,
      appBar: AppBar(backgroundColor: Colors.black,),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainerEditClient("Cliente",_con),
           // _bannerApp(),
            _textLogin(),
            _textInput(hint: 'Tu nombre', icon: Icons.person),
            _ButtonRegister()
          ],
        ),
      ),
    ));
  }
  Future<bool> _onBackPressed() async {
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
    // Your back press code here...
    // displaySnackBar("--");
  }

  Widget _ButtonRegister(){

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
      alignment: Alignment.bottomCenter,
      child: Center(
        child: ButtonWidget(
          btnText: "Actualizar",
          onClick: (){
            _con.update();
          },
        ),
      ),

    );
  }


  Widget _textInput({ hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.grey[800],
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: _con.usernameController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          labelText: "Tu nombre",
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        'Editar perfil',
        style: TextStyle(
          color: Colors. white,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           GestureDetector(
             onTap: _con.showAlertDialog,
             child: CircleAvatar(
               backgroundImage: _con.imageFile != null ?
               AssetImage(_con.imageFile?.path ?? 'assets/img/profile.png') :
               _con.client?.image != null
                   ? NetworkImage(_con.client?.image)
                   : AssetImage(_con.imageFile?.path ?? 'assets/img/profile.png'),
               radius: 50,
             ),
           ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                _con.client?.email ?? '',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        );
  }

  void refresh() {
    setState(() {

    });
  }

}
