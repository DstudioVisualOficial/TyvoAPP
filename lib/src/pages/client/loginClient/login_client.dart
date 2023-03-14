
import 'dart:io';
import 'package:uber/src/utils/snackbar.dart' as utils;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/homes/widgets/herder_containerClient.dart';
import 'package:uber/src/pages/client/loginClient/registerScreen.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/utils/shared_pref.dart';

import 'loggedInScreen.dart';
//import 'package:foreground_service/foreground_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class LoginClient extends StatefulWidget {
  @override
  _LoginClientState createState() => _LoginClientState();
}

class _LoginClientState extends State<LoginClient> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _typeUser;
  final TextEditingController numberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();
  SharedPref _sharedPref;
  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  @override
  void initState()  {
    _sharedPref = new SharedPref();
    checkuser();

    if (_auth.currentUser != null) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoggedInScreen(),
        ),
            (route) => false,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:  Scaffold(
          backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: ListView(children: [
          HeaderContainerClient("Tyvo"),
          new Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                  Container(
                  margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey[900],
            ),
            padding: EdgeInsets.only(left: 10),
            child:  TextFormField(

                              enabled: !isLoading,
                              controller: numberController,
                              style: TextStyle(color: Colors.white),
                              cursorColor: blackColors,
                              keyboardType: TextInputType.phone,
                              decoration:
                              InputDecoration(   border: InputBorder.none ,labelText: 'Numero de celular', labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.phone, color: Colors.white,),),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Porfavor escribir el numero de celular';
                                }
                              },
                            ),
                          ),
                      Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: !isLoading
                                  ? new ButtonWidget(
                                     onClick: ()
                                     async {
                                  if (!isLoading) {
                                    if (_formKey.currentState
                                        .validate()) {
                                      utils.Snackbar.showSnacbar(context, _scaffoldKey, 'Espere un momento...');

                                      await login();
                                    }
                                  }
                                }
                                ,btnText: "CONFIRMAR",
                                    )


                                  : CircularProgressIndicator(
                                backgroundColor:
                                Theme.of(context).primaryColor,
                              ))),
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        "¿No estas registrado?",style: TextStyle(color: Colors.white),
                                      )),
                                  InkWell(
                                    child: Text(
                                      'Registrate', style: TextStyle(color: blackColors),
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()))
                                    },
                                  ),
                                ],
                              )))
                    ],
                  ))
            ],
          )
        ])));
  }

  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
  }
  Widget returnOTPScreen() {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:  Scaffold(
          backgroundColor: Colors.black,
        key: _scaffoldKey,

        body: ListView(children: [
          HeaderContainer("Verificar codigo"),
          Form(
            key: _formKeyOTP,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                            !isLoading
                                ? "Introduzca el codigo de verificacion"
                                : "Enviando el codigo de verificacion",
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white),))),
                !isLoading
                    ?    Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[900],
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                        enabled: !isLoading,
                        controller: otpController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: null,
                        autofocus: true,
                        cursorColor: blackColors,
                        decoration: InputDecoration(
                            labelText: 'Codigo de Verificacion',
                          border: InputBorder.none, labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.phone, color: Colors.white,),),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Escriba el codigo de verificacion';
                          }
                        },
                      ),
                    )
                    : Container(),
                !isLoading
                    ? Container(
                    margin: EdgeInsets.only(top: 40, bottom: 5),
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: new ButtonWidget(
                          onClick: () async {
                            if (_formKeyOTP.currentState.validate()) {
                              // If the form is valid, we want to show a loading Snackbar
                              // If the form is valid, we want to do firebase signup...
                              setState(() {
                                isResend = false;
                                isLoading = true;
                              });
                              try {
                                await _auth
                                    .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                        verificationCode,
                                        smsCode: otpController.text
                                            .toString()))
                                    .then((user) async => {
                                  //sign in was success
                                  if (user != null)
                                    {
                                      //store registration details in firestore database
                                      setState(() {
                                        isLoading = false;
                                        isResend = false;
                                      }),
                                      saveTypeUser('client'),
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              ClientMapPage(),
                                        ),
                                            (route) => false,
                                      )
                                    }
                                })
                                    .catchError((error) => {
                                  setState(() {
                                    isLoading = false;
                                    isResend = true;
                                  }),
                                });
                                setState(() {
                                  isLoading = true;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          }

                          ,btnText: "INICIAR SESION",
                        )


                    ))
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor:
                            Theme.of(context).primaryColor,
                          )
                        ].where((c) => c != null).toList(),
                      )
                    ]),
                isResend
                    ? Container(
                    margin: EdgeInsets.only(top: 40, bottom: 5),
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: new ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isResend = false;
                              isLoading = true;
                            });
                            await login();
                          },
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "Re enviar Codigo",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                    : Column()
              ],
            ),
          )
        ])));
  }


  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+52 ' + numberController.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = numberController.text.trim();

    await _firestore.collection('Clients')
        .where("cellnumber",isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
            if (user != null)
              {
                //redirect
                setState(() {
                  isLoading = false;
                  isOTPScreen = false;
                }),
                saveTypeUser('client'),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ClientMapPage(),
                  ),
                      (route) => false,
                )
              }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          utils.Snackbar.showSnacbar(context, _scaffoldKey, 'Validation error, please try again later: $error');

          print("$error");
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      utils.Snackbar.showSnacbar(context,_scaffoldKey, 'El numero no esta registrado, Registrate');


    }

  }

  Widget _bannerApp(){
    return
            Image.asset(
              'assets/img/logo_app.png',
              width: 400,
              height: 200,
            );
  }
  Widget _bannerAppp() {
    return Lottie.asset(
        'assets/json/enter-otp.json',
        width: MediaQuery
            .of(context)
            .size
            .width*0.30 ,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.30,
        fit: BoxFit.fill,
        alignment: Alignment.center
    );
  }

  void checkuser() async {
    _typeUser =  await _sharedPref.read("typeUser");
    print('===================Tipo de usuario =======================');
    print(_typeUser);
  }
  Future<bool> _onBackPressed() async {
   // await ForegroundService.stopForegroundService();
    await  utils.Snackbar.showSnacbar(context, _scaffoldKey, "Cargando...");
    exit(0);
  }
}
