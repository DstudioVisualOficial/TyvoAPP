
import 'dart:async';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/client/loginClient/login_client.dart';
import 'package:uber/src/pages/home/home_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/utils/shared_pref.dart';

class  DriverMapControllerCotizacion {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(28.1908294, -105.4788793),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
 DriverProvider _clientProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;

  Driver client;
  AlertDialog alert;
  String from;
  LatLng fromLatLng;

  String to;
  LatLng toLatLng;

  double operacion;

  bool isFromSelected = true;

  SharedPref _sharedPref;
  String stylemapsave;
  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      apiKey: Environment.API_KEY_MAPS);

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    stylemapsave = await _sharedPref.read('stylemap');
    utils.Snackbar.showSnacbar(
        context, key, 'Cargando tu ubicacion, espere un momento...');
    AlertDialog alert = new AlertDialog();
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new DriverProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    checkGPS();
    //saveToken();
    getClientInfo();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> clientStream = _clientProvider.getByIdStream(
        _authProvider
            .getUser()
            .uid);
    _clientInfoSubscription = clientStream.listen((DocumentSnapshot document) {
      client = Driver.fromJson(document.data());
      refresh();
    });
  }


  void openDrawer() {
    key.currentState.openDrawer();
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSubscription?.cancel();
  }

  void signOut() async {
      //redirect
      _auth.signOut().then((value) => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePages())));

  }

  void onMapCreated(GoogleMapController controller) {
    if(stylemapsave == 'true'){
      controller.setMapStyle('[{"elementType": "geometry","stylers": [{"color": "#242f3e"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#6b9a76"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},{"featureType": "road","elementType": "geometry.stroke","stylers": [{"color": "#212a37"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#f3d19c"}]},{"featureType": "transit","elementType": "geometry","stylers": [{"color": "#2f3948"}]},{"featureType": "transit.station","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},{"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}]');
      _mapController.complete(controller);
      refresh();
    }
    else
    {
      //controller.setMapStyle('');
      _mapController.complete(controller);
      refresh();
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); // UNA VEZ
      centerPosition();
      //getNearbyDrivers();
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void requestDriver() async {

    try{


        if (fromLatLng != null && toLatLng != null) {


      Navigator.pushNamed(context, 'driver/map/cotizacion/info', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
        'username': client.username,


      });}    else {
      utils.Snackbar.showSnacbar(
          context, key, 'Seleccionar el lugar de recogida y destino');
    }}
  catch(Exception){
  print(Exception);
  }

}

  void changeFromTO() {
    isFromSelected = !isFromSelected;

    if (isFromSelected) {
      utils.Snackbar.showSnacbar(
          context, key, 'Estas seleccionando el lugar de recogida');
    }
    else {
      utils.Snackbar.showSnacbar(
          context, key, 'Estas seleccionando el destino');
    }
  }

  Future<Null> showGoogleAutoComplete(bool isFrom) async {
    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Environment.API_KEY_MAPS,
        mode: Mode.overlay,
        language: 'es',
        strictbounds: true,
        radius: 1964375,
        location: places.Location(_position.latitude, _position.longitude)

    );

    if (p != null) {
      places.PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId, language: 'es');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      List<Address> address = await Geocoder.local.findAddressesFromQuery(
          p.description);
      if (address != null) {
        if (address.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address[0].locality;
            String department = address[0].adminArea;

            if (isFrom) {
              from = '$direction, $city, $department';
              fromLatLng = new LatLng(lat, lng);

            }
            {
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }

            refresh();
          }
        }
      }
    }
    refresh();
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;

          if (isFromSelected) {
            from = '$direction #$street, $city, $department';
            fromLatLng = new LatLng(lat, lng);
           /* Timer(Duration(seconds: 3), () {
              utils.Snackbar.showSnacbar(
                  context, key, 'Cargando tu ubicacion, espere un momento...');
              utils.Snackbar.showSnacbar(
                  context, key, 'Ubicacion en proceso, Por el momento no arrastre su pantalla...');
              isFromSelected = false;
              print(from);
              print("--------------------------------Yeah, this line is printed after 5 seconds");
            });*/
          }
          else {
            to = '$direction #$street, $city, $department';
            toLatLng = new LatLng(lat, lng);
          }

          refresh();
        }
      }
    }
  }

  void goToEditPage() {
    Navigator.pushNamed(context, 'driver/edit');
  }


  void goToMainMap() {
    Navigator.pushNamed(context, 'driver/map');
  }
 /* void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider
        .getUser()
        .uid, 'client');
  }*/


  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else {
      utils.Snackbar.showSnacbar(
          context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
      updateLocation();
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('ACTIVO EL GPS');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 18
          )
      ));
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
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading
    );

    markers[id] = marker;
  }

}