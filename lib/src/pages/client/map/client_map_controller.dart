
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/client/edit/delete_user_page.dart';
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
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/pages/client/pagesClient/splash_page.dart';
class ClientMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(28.1908294, -105.4788793),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static final DateFormat formatter =DateFormat('yyyy-MM-dd');
  static final DateFormat formatter2 =DateFormat('yMd');
  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _fechaSuscription;
  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;

  ClientPhone client;

  String from;
  LatLng fromLatLng;

  String to;
  LatLng toLatLng;
  SharedPref _sharedPref;
  bool isFromSelected = true;

  places.GoogleMapsPlaces _places = places.GoogleMapsPlaces(
      apiKey: Environment.API_KEY_MAPS);

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _sharedPref = new SharedPref();
    _sharedPref.remove('isNotification');
    _sharedPref.save('isNotification', 'false');
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    checkGPS();
    saveToken();
    getClientInfo();
    checkFecha();
  }

  void getClientInfo() {
    Stream<DocumentSnapshot> clientStream = _clientProvider.getByIdStream(
        _authProvider
            .getUser()
            .uid);
    _clientInfoSubscription = clientStream.listen((DocumentSnapshot document) {
      client = ClientPhone.fromJson(document.data());
      refresh();
    });
  }


  void openDrawer() {
    key.currentState.openDrawer();
  }

  void dispose() {
    _fechaSuscription?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSubscription?.cancel();
  }

  void signOut() async {
      //redirect
      _auth.signOut().then((value) => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SplashPage())));

  }

  void onMapCreated(GoogleMapController controller) {
    /*controller.setMapStyle(
        '');*/
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); // UNA VEZ
      centerPosition();
      getNearbyDrivers();
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void requestDriver() {
    if (fromLatLng != null && toLatLng != null) {
      Navigator.pushNamed(context, 'client/travel/info', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
      });
    }
    else {
      utils.Snackbar.showSnacbar(
          context, key, 'Seleccionar el lugar de recogida y destino');
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
        language: 'es',
        strictbounds: true,
        radius: 5000,
        location: places.Location(28.1908294, -105.4788793)

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
            else {
              to = '$direction, $city, $department';
              toLatLng = new LatLng(lat, lng);
            }

            refresh();
          }
        }
      }
    }
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => DeleteUserPage()));
  }

  void goToHistoryPage() {
    Navigator.pushNamed(context, 'client/history');
  }

  void goToCupons(){
    Navigator.pushNamed(context, 'ClientCupons');
  }
  void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider
        .getUser()
        .uid, 'client');
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream =
    _geofireProvider.getNearbyDrivers(
        _position.latitude, _position.longitude, 50);

    stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('DOCUMENT: $d');
      }

      for (MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
      }

      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(
            d.id,
            point.latitude,
            point.longitude,
            'Conductor disponible',
            d.id,
            markerDriver
        );
      }

     // refresh();
    });
  }

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
              zoom: 17
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


  void checkFecha() async {

    if (client != null &&
        client.descuento == 0 ||
        client.descuento == null ||
        client.viajes == '0') {
      Map<String, dynamic> date = {
        'code': '',
        'viajes': '',
        'fechavencimiento': '',
        'descuento': '1'
      };
      await _clientProvider.update(date, _authProvider.getUser().uid);
    } else if (client.fechavencimiento == null ||
        client.fechavencimiento == '') {
      print('La fecha es null -------------------');
    } else {
      final fecha = DateTime.fromMillisecondsSinceEpoch(
          client.fechavencimiento.millisecondsSinceEpoch);
      final ahora = DateTime.now();

      if (ahora.isAfter(fecha)) {
        print("Fecha actual mayor");
        utils.Snackbar.showSnacbar(
            context, key, "Tu codigo ha expirado");
        Map<String, dynamic> date = {
          'code': '',
          'viajes': '',
          'fechavencimiento': '',
          'descuento': '1'
        };
        await _clientProvider.update(date, _authProvider.getUser().uid);
      }
      else
        {
          print('FECHA ATUAL MENOR =======================================');
        }
    }
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