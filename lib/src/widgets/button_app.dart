import 'package:flutter/material.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:uber/src/homes/utils/color.dart';
class ButtonApp extends StatelessWidget {
  Color color ;
  Color textColor;
  String texto;
  IconData icon;
  Function onPressed;
  ButtonApp({
   this.color = Colors.purpleAccent,
    this.textColor = Colors.white,
    this.onPressed,
    this.icon = Icons.arrow_forward_ios_sharp,
   @required this.texto
});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
    onPressed:  (){
      onPressed();
    },
    color: color,
      textColor: textColor,
      child:  Stack(/* permite poner metodos arriba del otro*/
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              alignment: Alignment.center,
                child: Text(texto, style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              child: CircleAvatar(
                radius: 15,

                child: Icon(icon, color: utils.Colors.uberColor
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
    
    );
  }
}
