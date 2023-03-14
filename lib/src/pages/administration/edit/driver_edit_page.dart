import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container_edit_driver.dart';
import 'package:uber/src/pages/administration/edit/driver_edit_controller.dart';
import 'package:uber/src/pages/driver/edit/driver_edit_controller.dart';
import 'package:uber/src/pages/driver/register/driver_register_controller.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/utils/otp_widget.dart';
import 'package:uber/src/widgets/button_app.dart';

class DriverEditAdminPage extends StatefulWidget {
  @override
  _DriverEditAdminPageState createState() => _DriverEditAdminPageState();
}

class _DriverEditAdminPageState extends State<DriverEditAdminPage> {

  DriverEditAdminController _con = new DriverEditAdminController();

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

    print('METODO BUILD');

    return Scaffold(
      key: _con.key,
      appBar: AppBar(backgroundColor: Colors.black,),
      backgroundColor: Colors.black,
      bottomNavigationBar: _buttonRegister(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderContainerEditDriver("Driver",_con),
            _textLogin(),
            _textLicencePlate(),
            _textInputEnabled(controller: _con.plateController, hint: 'Placas', icon: Icons.wysiwyg, type: TextInputType.text),
            _textInput(controller: _con.usernameController, hint: 'Tu nombre', icon: Icons.person_outline_outlined, type: TextInputType.text),

          ],
        ),
      ),
    );
  }
  Widget _textInput({ controller, hint, icon, type}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[800],
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }
  Widget _textInputEnabled({ controller, hint, icon, type}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[800],
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        enabled: false,
        style: TextStyle(color: Colors.white),
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }
  Widget _buttonRegister() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonWidget(
        onClick: _con.update,
        btnText: 'CONFIRMAR',
      ),
    );
  }



  Widget _textLicencePlate() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
          'Placa del vehiculo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        'Confirmar Perfil',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return  Container(
        color: Colors.purpleAccent,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _con.showAlertDialog,
              child: CircleAvatar(
                backgroundImage: _con.imageFile != null ?
                AssetImage(_con.imageFile?.path ?? 'assets/img/profile.png') :
                _con.driver?.image != null
                    ? NetworkImage(_con.driver?.image)
                    : AssetImage(_con.imageFile?.path ?? 'assets/img/profile.png'),
                radius: 50,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                _con.driver?.email ?? '',
                style: TextStyle(
                    fontFamily: '',
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
    );
  }

  void refresh() {
    setState(() {

    });
  }


}
