import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/pages/client/pagesClient/splash_page.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/utils/shared_pref.dart';
//import 'package:foreground_service/foreground_service.dart';
import 'login_controller.dart';

class LoginPageDriver extends StatefulWidget {
  @override
  _LoginPageDriverState createState() => _LoginPageDriverState();
}

class _LoginPageDriverState extends State<LoginPageDriver> {
  LoginController _con  = new LoginController();
  SharedPref _sharedPref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPref = new SharedPref();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);

    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.black,
      key: _con.key,
      body:SingleChildScrollView(
        child: Column(
            children: [
              HeaderContainer("Conductor"),
              _textInput(hint: "Email", icon: Icons.email),
                    _textInputpass(hint: "Password", icon: Icons.vpn_key),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                     /* child: Text(
                        "Forgot Password?",
                      ),*/
                    ),
                 _ButtonLogin(),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "No estas registrado? ",
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: "Contacta al administrador",
                            style: TextStyle(color: blackColors)),
                      ]),
                    )
                  ],
                ),
              ),
            )
        );
  }
  Widget _ButtonLogin(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Center(
        child: ButtonWidget(
          btnText: "Iniciar Sesion",
          onClick: (){
            _con.login();
          },
        ),
      ),

    );
  }
  Widget _textInput({ hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[900]

      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        cursorColor: blackColors,
        controller: _con.emailController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }
  Widget _textInputpass({hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[900]
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: _con.passwordController,
        obscureText: true,
        cursorColor: blackColors,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.white,),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {

    await  utils.Snackbar.showSnacbar(context, _con.key, "Saliendo...");
    await Future.delayed(Duration(milliseconds: 2000),(){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SplashPage()));

    });

    // Your back press code here...
    // displaySnackBar("--");
  }

}
