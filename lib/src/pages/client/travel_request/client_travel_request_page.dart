
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/travel_request/client_travel_request_controller.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/widgets/button_app.dart';

class ClientTravelRequestPage extends StatefulWidget {
  @override
  _ClientTravelRequestPageState createState() => _ClientTravelRequestPageState();
}

class _ClientTravelRequestPageState extends State<ClientTravelRequestPage> {

  ClientTravelRequestController _con = new ClientTravelRequestController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      backgroundColor: Colors.black,
      body: Column (

     children: [
      // _driverInfo(),

       _lottieAnimation(),
       SizedBox(height: 30,),
       _textLookingFor(),
      // _textCounter(),


     ],
      ),
      bottomNavigationBar: _buttonCancel(),
    );
  }

Widget _driverInfo(){
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: Colors.black,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           CircleAvatar(
           radius: 50,
           backgroundImage: AssetImage('assets/img/profile.jpg'),
         ),
         Container(
           margin: EdgeInsets.symmetric(vertical: 10),
           child: Text('Tu conductor',
           maxLines: 1,
           style: TextStyle(
             fontSize: 18,
             color: Colors.white
           ),
           ),
         ),],
        ),
      );
}



    Widget _buttonCancel(){
    return ButtonWidget(
            onClick: _con.canceltravel,
            btnText: 'Cancelar Viaje',


    );
    }

    Widget _textCounter(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text( _con.seconds.toString(),
        style:  TextStyle(
          fontSize: 30,
              color: Colors.white
        ),

      ),
    );
    }


    Widget _lottieAnimation(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      color: Colors.black,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Lottie.asset(


        'assets/json/LoadingDstudio.json',
        width: MediaQuery.of(context).size.width * 0.60,
        height: MediaQuery.of(context).size.height * 0.40,
        fit: BoxFit.fill,

      )],
      ),
    );
    }



    Widget _textLookingFor(){
    return Container(
      child: Text(
        'Esperando conductor',
        style: TextStyle(
          fontSize: 16,
              color: Colors.white
        ),


      ),
    );
    }

  void refresh(){
    setState(() {
    });
  }


}
