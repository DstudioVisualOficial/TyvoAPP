import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/pages/client/loginClient/login_client.dart';
import 'package:uber/src/pages/driver/loginDriver/login_driver.dart';
import 'package:uber/src/pages/home/home_page.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var userName = '';

class LoggedInScreenDriver extends StatefulWidget {
  LoggedInScreenDriver ({Key key}) : super(key: key);

  @override
  _LoggedInScreenDriverState createState() => _LoggedInScreenDriverState();
}

class _LoggedInScreenDriverState extends State<LoggedInScreenDriver> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Bienvenido a Tyvo' + userName,
            style: TextStyle(fontSize: 30),
          ),
          Text('(Tu numero de celular: ' +
              (_auth.currentUser.phoneNumber != null
                  ? _auth.currentUser.phoneNumber
                  : '') +
              ')'),
          ElevatedButton(
              onPressed: () => {
                    //sign out
                    signOut()
                  },
              child: Text('Continuar'))
        ],
      ),
    ));
  }

  Future getUser() async {
    if (_auth.currentUser != null) {
      var cellNumber = _auth.currentUser.phoneNumber;
      cellNumber =
          '0' + _auth.currentUser.phoneNumber.substring(3, cellNumber.length);
      debugPrint(cellNumber);
      await _firestore
          .collection('Drivers')
          .where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result) {
        if (result.docs.length > 0) {
          setState(() {
            userName = result.docs[0].data()['name'];
          });
        }
      });
    }
  }

  signOut() {
    //redirect
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePages())));
  }
}
