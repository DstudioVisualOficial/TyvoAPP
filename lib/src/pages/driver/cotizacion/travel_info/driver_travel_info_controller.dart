import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/models/directions.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/prices.dart';
import 'package:uber/src/pages/driver/cotizacion/travel_map/driver_travel_map_taximetro_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/google_provider.dart';
import 'package:uber/src/providers/history_agenda_taximetro_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uuid/uuid.dart';
class DriverTravelInfoController{
  BuildContext context;
  GoogleProvider _googleProvider;


  var uuid = Uuid();
  PricesProvider _pricesProvider;
  AuthProvider _authProvider;

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

  double fromLatLnglatitude;
  double fromLatLnglongitude;
  double toLatLnglatitude;
  double toLatLnglongitude;

  DriverProvider _driverProvider;



  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  HistoryAgendaTaximetroProvider _historyAgenda;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  var hoy = DateTime.now();
  var nuevafecha;
  double total = 0;
  Direction _directions;
  String min;
  String base;
  String km;
  double price;
  String username;
  double minTotal;
  double maxTotal;
  double medTotal;
  SharedPref _sharedPref;
  String stylemapsave;

  Future init(BuildContext context, Function refresh )async{
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    stylemapsave = await _sharedPref.read('stylemap');

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    username = arguments['username'];
    _historyAgenda = HistoryAgendaTaximetroProvider();
    _googleProvider = new GoogleProvider();
    _authProvider = new AuthProvider();
    _pricesProvider = new PricesProvider();
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');
    _driverProvider = new DriverProvider();
    animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
    getGoogleMapsDirections(fromLatLng, toLatLng);
  }
  void backLayout(){
    Navigator.pushNamedAndRemoveUntil(context, 'driver/map/cotizacion', (route) => false);
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
      double baseValue = prices.base;
      total = kmValue + minValue + baseValue;
      price = double.parse(total.toString());
      medTotal = total;

      refresh();
  }
  void saveTravel(String status){
    _sharedPref.remove('status');
    _sharedPref.save("status", status);
  }
  void goToRequest()async {
    try {
      Map<String, dynamic> data = {
        'from': from,
        'to': to,
        'fromLatLnglatitude': fromLatLnglatitude,
        'fromLatLnglongitude': fromLatLnglongitude,
        'toLatLnglatitude': toLatLnglatitude,
        'toLatLnglongitude': toLatLnglongitude,
        'total': total,
      };
      await _driverProvider.update(data, _authProvider
          .getUser()
          .uid);
/*      TravelHistoryAgenda dat = new TravelHistoryAgenda(
        status: 'Viaje Iniciado',
          km: km,
          min: min,
          fecha: hoy.toString(),
          id: uuid.v4(),
          iddriver: _authProvider
              .getUser()
              .uid,
          from: from ?? "VIAJE INICIADO",
          to: to ?? "VIAJE INICIADO",
          timestamp: DateTime
              .now()
              .millisecondsSinceEpoch,
          nameDriver: username,
          cellclient: 'Sin datos',
          nameClient: 'Sin datos',
          price: total,
          comentariodes: 'Sin datos'
      );
      await _historyAgenda.create(dat);*/
     /** print('El usuario registro la cotizacion correctamente ');
      utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");*/
      saveTravel('acceptedcot');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DriverTravelMapTaximetroPage(),
        ),
            (route) => false,
      );
    } catch (e) {
      print(e);
    }
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
    fromLatLnglatitude = fromLatLng.latitude;
    fromLatLnglongitude = fromLatLng.longitude;
    toLatLnglatitude = toLatLng.latitude;
    toLatLnglongitude = toLatLng.longitude;

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
    if(stylemapsave == 'true'){
      controller.setMapStyle('[{"elementType": "geometry","stylers": [{"color": "#242f3e"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#6b9a76"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},{"featureType": "road","elementType": "geometry.stroke","stylers": [{"color": "#212a37"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#f3d19c"}]},{"featureType": "transit","elementType": "geometry","stylers": [{"color": "#2f3948"}]},{"featureType": "transit.station","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},{"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}]');
      _mapController.complete(controller);
      await setPolylines();
    }
    else
    {
      //controller.setMapStyle('');
      _mapController.complete(controller);
      await setPolylines();

    }
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