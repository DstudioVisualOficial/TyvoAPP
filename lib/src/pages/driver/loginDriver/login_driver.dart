
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber/src/pages/administration/login_page_admin.dart';
import 'package:uber/src/pages/client/loginClient/registerScreen.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/pages/driver/loginDriver/registerScreenDriver.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/pages/login/login_page.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

import 'loggedInScreenDriver.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class LoginDriver extends StatefulWidget {
  @override
  _LoginDriverState createState() => _LoginDriverState();
}

class _LoginDriverState extends State<LoginDriver> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref _sharedPref;
  final TextEditingController numberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  @override
  void initState() {
    _sharedPref = new SharedPref();
    if (_auth.currentUser != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoggedInScreenDriver(),
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
        ),
        body: ListView(children: [
          _bannerApp(),
          new Column(

            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              "Bienvenido Conductor",style: TextStyle(
                              fontSize: 20
                            ),
                            )
                          )),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: numberController,
                              keyboardType: TextInputType.phone,
                              decoration:
                              InputDecoration(labelText: 'Numero de celular'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Porfavor escribir el numero de celular';
                                }
                              },
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: !isLoading
                                  ? new ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    if (_formKey.currentState
                                        .validate()) {
                                      displaySnackBar('Espere un momento...');
                                      await login();
                                    }
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            child: Text(
                                              "Confirmar",
                                              textAlign: TextAlign.center,
                                            )),
                                      ],
                                    )),
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
                              const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Text(
                                        "¿No estas registrado?",
                                      )),

                                  InkWell(
                                    child: Text(
                                      'Contacta al Administrador',
                                    ),
                                    onTap: RegistrarTypeUser,
                                  )],
                              )))
                    ],
                  ))
            ],
          )
        ]));
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
        ),
        body: ListView(children: [
          _bannerAppp(),
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
                            textAlign: TextAlign.center))),
                !isLoading
                    ? Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: TextFormField(
                        enabled: !isLoading,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialValue: null,
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: '*********',
                            labelText: 'Codigo de Verificacion',
                            labelStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Escriba el codigo de verificacion';
                          }
                        },
                      ),
                    ))
                    : Container(),
                !isLoading
                    ? Container(
                    margin: EdgeInsets.only(top: 40, bottom: 5),
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: new ElevatedButton(
                          onPressed: () async {
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
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              DriverMapPage(),
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
                                    "Iniciar sesion",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
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
        ]));
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+52 ' + numberController.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = numberController.text.trim();

    await _firestore.collection('Drivers')
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DriverMapPage(),
                  ),
                      (route) => false,
                )
              }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Validation error, please try again later: $error');
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
      displaySnackBar('El numero no esta registrado, Lo sentimos');
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
  void RegistrarTypeUser() async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", "admin");
  Navigator.pushNamed(context, "loginAdmin");
  }
}
