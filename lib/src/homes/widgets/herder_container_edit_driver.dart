import 'package:flutter/material.dart';
import 'package:uber/src/homes/utils/color.dart';

class HeaderContainerEditDriver extends StatelessWidget {
  var text = "Login";
  var _con;
  HeaderContainerEditDriver(
      this.text
      ,this._con


      );

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
          Container(
            margin: EdgeInsets.only(bottom: 40),
            alignment: Alignment.bottomCenter,
            child: Text(
              _con.driver?.email ?? '',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Center(
            child: GestureDetector(
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
          ),

        ],
      ),
    );
  }
}
