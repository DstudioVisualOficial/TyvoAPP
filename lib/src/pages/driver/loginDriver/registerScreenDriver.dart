import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/pages/client/map/client_map_controller.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'loggedInScreenDriver.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final AuthProvider _authProvider = new AuthProvider();
class RegisterScreenDriver extends StatefulWidget {
  RegisterScreenDriver({Key key}) : super(key: key);

  @override
  _RegisterScreenDriverState createState() => _RegisterScreenDriverState();
}

class _RegisterScreenDriverState extends State<RegisterScreenDriver> {

  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController placaController = new TextEditingController();
  final TextEditingController colorController = new TextEditingController();
  final TextEditingController cellnumberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    cellnumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : registerScreen();
  }

  Widget registerScreen() {
    final node = FocusScope.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
        ),
        body: ListView(children: [_bannerApp(),
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
                                "Nombre completo",style: TextStyle(
                                  fontSize: 15
                              ),
                              )
                          )),
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Nombre completo'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor escribe tu nombre completo';
                            }
                          },
                        ),
                      )),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                "Placa del vehiculo",style: TextStyle(
                                  fontSize: 15
                              ),
                              )
                          )),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: placaController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  labelText: 'Placa'),
                            ),
                          )),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                "Color del auto",style: TextStyle(
                                  fontSize: 15,
                              ),
                              )
                          )),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: colorController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  labelText: 'Color del Auto'),
                            ),
                          )),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                "Correo electronico",style: TextStyle(
                                  fontSize: 15
                              ),
                              )
                          )),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                                  labelText: 'Correo electronico'),
                            ),
                          )),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                "Numero de celular",style: TextStyle(
                                  fontSize: 15
                              ),
                              )
                          )),
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          enabled: !isLoading,
                          keyboardType: TextInputType.phone,
                          controller: cellnumberController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => node.unfocus(),
                          decoration: InputDecoration(
                              hintText: '*********',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Numero de celular'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor introduzca su numero de celular';
                            }
                          },
                        ),
                      )),
                      Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: new ElevatedButton(
                                onPressed: () {
                                  if (!isLoading) {
                                    if (_formKey.currentState.validate()) {
                                      // If the form is valid, we want to show a loading Snackbar
                                      setState(() {
                                        signUp();
                                        isRegister = false;
                                        isOTPScreen = true;
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
                                          "Siguiente",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
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
        body: ListView(children: [_bannerApp(),
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
                              labelText: 'Codigo de verificacion',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor escriba el codigo de verificacion';
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
                                                  await _firestore
                                                      .collection('Drivers')
                                                      .doc(
                                                          _auth.currentUser.uid)
                                                      .set(
                                                          {
                                                        'username': nameController
                                                            .text
                                                            .trim(),
                                                        'cellnumber':
                                                            cellnumberController
                                                                .text
                                                                .trim(),
                                                            'id':
                                                                _auth.currentUser.uid,
                                                            'email':
                                                                emailController.text.trim(),
                                                            'color' :
                                                                colorController.text.trim(),
                                                            'plate' :
                                                                placaController.text.trim()

                                                      },
                                                          SetOptions(
                                                              merge:
                                                                  true)).then(
                                                          (value) => {
                                                                //then move to authorised area
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  isResend =
                                                                      false;
                                                                })
                                                              }),

                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoggedInScreenDriver(),
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
                                await signUp();
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
                                        "Re enviar codigo",
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

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('Gideon test 1');
    var phoneNumber = '+52 ' + cellnumberController.text.toString();
    debugPrint('Gideon test 2');
    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
              if (user != null)
                {
                  //store registration details in firestore database
                  await _firestore
                      .collection('Drivers')
                      .doc(_auth.currentUser.uid)
                      .set({
                        'username': nameController.text.trim(),
                        'cellnumber': cellnumberController.text.trim(),
                        'email': emailController.text.trim(),
                        'id': _auth.currentUser.uid,
                        'color': colorController.text.trim(),
                        'plate': placaController.text.trim()
                      }, SetOptions(merge: true))
                      .then((value) => {
                            //then move to authorised area
                            setState(() {
                              isLoading = false;
                              isRegister = false;
                              isOTPScreen = false;

                              //navigate to is
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoggedInScreenDriver(),
                                ),
                                (route) => false,
                              );
                            })
                          })
                      .catchError((onError) => {
                            debugPrint(
                                'Error saving user to db.' + onError.toString())
                          })
                }
            });
        debugPrint('Gideon test 4');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Gideon test 5' + error.message);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        debugPrint('Gideon test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Gideon test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
    debugPrint('Gideon test 7');
    await verifyPhoneNumber;
    debugPrint('Gideon test 8');
  }
  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo() ,
      child:      Container(
        color: utils.Colors.uberColor,
        height: MediaQuery.of(context).size.height*0.22,
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
}
