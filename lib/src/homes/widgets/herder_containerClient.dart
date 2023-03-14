import 'package:flutter/material.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/driver/pagesDriver/splash_page.dart';
class HeaderContainerClient extends StatelessWidget {
  var text = "Login";
  String admin = 'admin';


  HeaderContainerClient(this.text);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black,Colors.grey[800],Colors.white,Colors.white,Colors.grey[800], Colors.black,],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0))),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20,
              right: 0,
              child: Text(
            text,
            style: TextStyle(color: Colors.white,fontSize: 20),
          )),
          Center(
              child: GestureDetector(
                onTap: (){


                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => SplashPageDriver())


                  );
                },
                child:      Container(
                  height: MediaQuery.of(context).size.height*0.25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/logo_app.png',
                        width: 300,
                        height: 400,
                      ),
                    ],
                  ),
                ),
              )

          ),
        ],
      ),
    );
  }
}
