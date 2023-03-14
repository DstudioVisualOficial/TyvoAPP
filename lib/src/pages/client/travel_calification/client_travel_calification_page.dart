import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/travel_calification/client_travel_calification_controller.dart';
import 'package:uber/src/widgets/button_app.dart';

class ClientTravelCalificationPage extends StatefulWidget {
  @override
  _ClientTravelCalificationPageState createState() => _ClientTravelCalificationPageState();
}

class _ClientTravelCalificationPageState extends State<ClientTravelCalificationPage> {

  ClientTravelCalificationController _con = new ClientTravelCalificationController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      backgroundColor: Colors.black,
      bottomNavigationBar: _buttonCalificate(),
      body: Column(
        children: [
          _bannerPriceInfo(),
          SizedBox(height: 30),
          _textCalificateYourDriver(),
          SizedBox(height: 15),
          _ratingBar(),
          _listTileTravelInfo('Desde', _con.travelHistory?.from ?? '', Icons.location_on),
          _listTileTravelInfo('Hasta', _con.travelHistory?.to ?? '', Icons.directions_subway),

        ],
      ),
    );
  }

  Widget _buttonCalificate() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonWidget(
        onClick: _con.calificate,
        btnText: 'CALIFICAR',

      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          initialRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          unratedColor: Colors.grey[300],
          onRatingUpdate: (rating) {
            _con.calification = rating;
            print('RATING: $rating');
          }
      ),
    );
  }
  
  Widget _textCalificateYourDriver() {
    return Text(
      'CALIFICA TU VIAJE',
      style: TextStyle(
        color: blackColors,
        fontWeight: FontWeight.bold,
        fontSize: 18
      ),
    );
  }

  Widget _listTileTravelInfo(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14
          ),
          maxLines: 2,
        ),
        leading: Icon(icon, color: Colors.white,),
      ),
    );
  }

  Widget _bannerPriceInfo() {
    return ClipPath(
      //clipper: MovieTicketClipper(),
      child: Container(
        height: 300,
        width: double.infinity,
        color: blackColors,
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 100),
              SizedBox(height: 20),
              Text(
                'TU VIAJE HA FINALIZADO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Tu viaje fue de :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '\$${_con.travelHistory?.price ?? '' }',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight:FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
