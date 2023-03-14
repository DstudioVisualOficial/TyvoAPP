import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:uber/src/pages/home/home_controller.dart';

//stful
class HomePages extends StatefulWidget {

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  HomeController _con = new HomeController();
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SafeArea(
        child: Container(
          height:  MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.white, Colors.black]   //degradado de color background
            )
          ),

            child: Column(
              children: [
             _bannerApp(context),
                SizedBox(height: 50,),
                _logo("driver"),
                SizedBox(height: 50,),
               // _textTyperUser('INICIAR'),
              _lottieAnimation("client"),
                _lottieAnimationn(),
                SizedBox(height: 30,),

                //SizedBox(height: 30,),
              //_imageTypeUser(context,'assets/img/driver.png', 'driver'),
               // SizedBox(height: 10,),
              // _textTyperUserr('Soy Conductor', "driver")
              ],
            ),
          ),
        ),
    );
  }

  void refresh() {
    setState(() {

    });
  }

  Widget _bannerApp(BuildContext context){
    return ClipPath(
      clipper: WaveClipperTwo() ,
      child:      Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height*0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Image.asset(
              'assets/img/logo_app.png',
              width: 300,
              height: 100,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _imageTypeUserClient(BuildContext context, String image, String typeUser){
    return GestureDetector(
      onTap: (){
        _con.gotologinpageClient(typeUser);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 50,
        backgroundColor: Colors.grey[900],
      ),
    );
  }
  Widget _logo(String typeUser){
    return GestureDetector(

      onTap: (){
        _con.gotologinpage("driver");
      },
      child: Image.asset(
        'assets/img/logo_app.png',
        width: 300,
        height: 180,
      )
    );
  }
  Widget _imageTypeUser(BuildContext context, String image, String typeUser){
    return GestureDetector(
      onTap: (){
        _con.gotologinpage(typeUser);
      },
      child: CircleAvatar(
    backgroundImage: AssetImage(image),
        radius: 50,
        backgroundColor: Colors.grey[900],
    ),
    );
  }

  Widget _textTyperUser(String typeUser){
      return Text(typeUser,
      style: TextStyle(
        color: Colors.white,
        fontFamily:'RobotoMedium',
        fontSize: 20,
      ),);
  }
  Widget _lottieAnimation(String typeUser){
    return GestureDetector(

      onTap: (){
        _con.gotologinpageClient(typeUser);
      },
      child: Lottie.asset(
          'assets/json/botton.json',
          width: MediaQuery.of(context).size.width * 0.30,
          height: MediaQuery.of(context).size.height * 0.20,
          fit: BoxFit.fill
      ),

    );

  }
  Widget _lottieAnimationn(){
    return GestureDetector(

      onTap: (){

      },
      child: Lottie.asset(
          'assets/json/botton.json',
          width: MediaQuery.of(context).size.width * 0.30,
          height: MediaQuery.of(context).size.height * 0.20,
          fit: BoxFit.fill
      ),

    );

  }
/*  Widget _textTyperUserr(String typeUser, String driver){
    return GestureDetector(
      onTap: (){
        _con.gotologinpage("driver");
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(vertical: 50 ),
            child:  Text(typeUser,
              style: TextStyle(
                color: Colors.blue,
                fontFamily:'RobotoMedium',
                fontSize: 15,
          ),
        ),
      ),
    );
  }*/

}
//control s es para actualizar el contenido