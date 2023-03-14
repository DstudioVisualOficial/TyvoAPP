import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'loggedInScreen.dart';
import 'package:uber/src/homes/widgets/herder_container.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final AuthProvider _authProvider = new AuthProvider();
class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
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
      backgroundColor: Colors.black,
        key: _scaffoldKey,
        body: ListView(children: [
          HeaderContainer("Registrar"),
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
            child:   TextFormField(
                          enabled: !isLoading,
                          controller: nameController,
                          cursorColor: blackColors,
                          style:  TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(border: InputBorder.none ,labelText: 'Nombre Completo', labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.person, color: Colors.white,),),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor escribe tu nombre completo';
                            }
                          },
                        ),
                      ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[900],
          ),
          padding: EdgeInsets.only(left: 10),
          child:  TextFormField(
                              enabled: !isLoading,
                              controller: emailController,
                               cursorColor: blackColors,
                              style:  TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  border: InputBorder.none , labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.email, color: Colors.white,),
                                  labelText: 'Correo electronico', hintStyle:  TextStyle(color: Colors.grey[600]), hintText: 'Ejemplo123@gmail.com'),
                            ),
                          ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[900],
          ),
          padding: EdgeInsets.only(left: 10),
          child:  TextFormField(
                          enabled: !isLoading,
                          keyboardType: TextInputType.phone,
                          cursorColor: blackColors,
                          controller: cellnumberController,
                          style: TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => node.unfocus(),
                          decoration: InputDecoration(
                              hintText: '*********',
                              labelText: 'Numero de celular', border: InputBorder.none , labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.phone, color: Colors.white,),hintStyle:  TextStyle(color: Colors.grey[600]),),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor introduzca su numero de celular';
                            }
                          },
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: new ButtonWidget(
                                onClick: ()
                                    {
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
                                }
                                ,btnText: "Registrarme",
                              )

                         )),
                    ],
                  ))
            ],
          )
        ]));
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: ListView(children: [ HeaderContainer("Verificar codigo")
        ,
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
                    ?         Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[900],
                ),
                padding: EdgeInsets.only(left: 10),
                child: TextFormField(
                          enabled: !isLoading,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          cursorColor: blackColors,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelText: 'Codigo de verificacion',
                            border: InputBorder.none , labelStyle: TextStyle(color: Colors.white), prefixIcon: Icon(Icons.person, color: Colors.white,),),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Porfavor escriba el codigo de verificacion';
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
                            child: new  ButtonWidget(
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
                                                  await _firestore
                                                      .collection('Clients')
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
                                                                emailController.text.trim()
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
                                                          LoggedInScreen(),
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
                              btnText: 'Confirmar',
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
                            child: new ButtonWidget(
                              onClick: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await signUp();
                              },
                              btnText: "Re enviar codigo",
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
                      .collection('Clients')
                      .doc(_auth.currentUser.uid)
                      .set({
                        'username': nameController.text.trim(),
                        'cellnumber': cellnumberController.text.trim(),
                        'email': emailController.text.trim(),
                        'id': _auth.currentUser.uid
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
                                      LoggedInScreen(),
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
    return
      Image.asset(
        'assets/img/logo_app.png',
        width: 400,
        height: 200,
      );
  }
  /*Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo() ,
      child:      Container(
        color: utils.Colors.uberColor,
        height: MediaQuery.of(context).size.height*0.32,
        child:   Lottie.asset(
    'assets/json/user-profile.json',
    width: MediaQuery.of(context).size.width * 0.20,
    height: MediaQuery.of(context).size.height * 0.20,
    fit: BoxFit.fill
    )
      ),
    );
  }*/
}
