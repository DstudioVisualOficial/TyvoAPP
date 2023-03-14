import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/models/directions.dart';
import 'package:uber/src/models/prices.dart';
import 'package:uber/src/providers/google_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';

class ClientTravelInfoController{
  BuildContext context;
  GoogleProvider _googleProvider;

  PricesProvider _pricesProvider;


  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(1.2342774, -77.2645446),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();


  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;


  Direction _directions;
  String min;
  String km;


  double minTotal;
  double totalprice;
  double maxTotal;



  Future init(BuildContext context, Function refresh )async{
      this.context = context;
      this.refresh = refresh;
      Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      from = arguments['from'];
      to = arguments['to'];
      fromLatLng = arguments['fromLatLng'];
      toLatLng = arguments['toLatLng'];
      _googleProvider = new GoogleProvider();
      _pricesProvider = new PricesProvider();
      fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
      toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

      animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
      getGoogleMapsDirections(fromLatLng, toLatLng);
  }

  void backLayout(){
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
  }
  void getGoogleMapsDirections(LatLng from, LatLng to)async{
      _directions = await _googleProvider.getGoogleMapsDirections(
          from.latitude,
          from.longitude,
          to.latitude,
          to.longitude
      );
      min = _directions.duration.text;
      km = _directions.distance.text;


      calculatePrice();
      refresh();
  }

  void calculatePrice()async{
    Prices prices = await _pricesProvider.getAll();
    double kmValue = double.parse(km.split(" ")[0]) * prices.km;
    double minValue = double.parse(min.split(" ")[0]) * prices.min;
    double total = kmValue + minValue + 30;


    minTotal = total - 6;
    totalprice = total;
    maxTotal = total + 10;
    refresh();
  }
void goToRequest(){
  Navigator.pushNamed(context, 'client/travel/type/request', arguments: {
  'from': from,
  'to' : to,
  'fromLatLng': fromLatLng,
  'toLatLng': toLatLng,
    'price': totalprice
});

}

  Future<void> setPolylines() async{
    PointLatLng pointFromLatLng = PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng = PointLatLng(toLatLng.latitude, toLatLng.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng);
    for(PointLatLng point in result.points){
        points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: blackColors,
      points: points,
      width: 6
    );

    polylines.add(polyline);
    addMarker('from', fromLatLng.latitude, fromLatLng.longitude, 'Recoger aqui', '', fromMarker);
    addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);
      refresh();
  }
  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 15
          )
      ));
    }
  }
  void onMapCreated(GoogleMapController controller) async{
    controller.setMapStyle(
        '');
    _mapController.complete(controller);
    await setPolylines();
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
  }

}