import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:uber/src/homes/utils/color.dart';
//import 'package:foreground_service/foreground_service.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/pages/administration/CuponsRegister/cupons_register.dart';
import 'package:uber/src/pages/administration/Tarifa/tarifa_admin_page.dart';
import 'package:uber/src/pages/administration/code/code_admin_page.dart';
import 'package:uber/src/pages/administration/eliminar_administrador/delete_administrador_page.dart';
import 'package:uber/src/pages/administration/eliminar_administrador/list_administrador.dart';
import 'package:uber/src/pages/administration/eliminar_conductor/delete_driver_page.dart';
import 'package:uber/src/pages/administration/eliminar_conductor/list_conductores.dart';
import 'package:uber/src/pages/administration/img/img_page.dart';
import 'package:uber/src/pages/administration/pagesAdmin/login_page.dart';
import 'package:uber/src/pages/administration/pagesAdmin/regi_page.dart';
import 'package:uber/src/pages/administration/pagesAdmin/splash_page.dart';
import 'package:uber/src/pages/client/cupons/client_cupons.dart';
import 'package:uber/src/pages/client/pagesClient/splash_page.dart';
import 'package:uber/src/pages/client/travel_request/client_travel_type_request_page.dart';
import 'package:uber/src/pages/client/verification/verificationRequest_page%20.dart';
import 'package:uber/src/pages/driver/HistoryAgenda/HistorialAgendaDetail.dart';
import 'package:uber/src/pages/driver/HistoryAgenda/HistorialAgendaPage.dart';
import 'package:uber/src/pages/driver/cotizacion/drive_map_page_cotizacion.dart';
import 'package:uber/src/pages/driver/cotizacion/registercot/driver_registercottaximetro_page.dart';
import 'package:uber/src/pages/driver/cotizacion/travel_info/driver_travel_info_page.dart';
import 'package:uber/src/pages/driver/cotizacion/travel_map/driver_travel_map_taximetro_page.dart';
import 'package:uber/src/pages/driver/history/driver_history_page.dart';
import 'package:uber/src/pages/driver/pagesDriver/regi_page.dart';
import 'package:uber/src/pages/driver/pagesDriver/splash_page.dart';
import 'package:uber/src/pages/driver/taximetroxpuntos/register_cotizacion_taximetroxpuntos/driver_register_cotizacion_taximetroxpuntos_page.dart';
import 'package:uber/src/utils/check_internet_connection.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/pages/client/loginClient/login_client.dart';
import 'package:uber/src/pages/client/travel_calification/client_travel_calification_page.dart';
import 'package:uber/src/pages/driver/edit/driver_edit_page.dart';
import 'package:uber/src/pages/driver/register/driver_register_page.dart';
import 'package:uber/src/pages/home/home_page.dart';
import 'package:uber/src/pages/administration/menu/menu_admin.dart';
import 'package:uber/src/pages/client/history/client_history_page.dart';
import 'package:uber/src/pages/client/register/client_register_page.dart';
import 'package:uber/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/pages/driver/travel_map/driver_travel_map_page.dart';
import 'package:uber/src/pages/administration/driver_register_page_admin.dart';
import 'package:uber/src/pages/client/edit/client_edit_page.dart';
import 'package:uber/src/pages/client/history_detail/client_history_detail_page.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:uber/src/pages/client/travel_map/client_travel_map_page.dart';
import 'package:uber/src/pages/driver/history_detail/driver_history_detail_page.dart';
import 'package:uber/src/pages/driver/travel_calification/driver_travel_calification_page.dart';
import 'package:uber/src/pages/driver/travel_request/driver_travel_request_page.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  FlutterRingtonePlayer.play(
    android: AndroidSounds.ringtone,
    ios: IosSounds.glass,
    looping: true, // Android only - API >= 28
    volume: 1.0, // Android only - API >= 28
    asAlarm: false, // Android only - all APIs
  );
  Future.delayed(Duration(milliseconds: 7000),()
  {
    FlutterRingtonePlayer.stop();
  });
}
final internetChecker = CheckInternetConnection();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());

 // maybeStartFGS();
}


GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {

    super.initState();
    PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();

    pushNotificationsProvider.message.listen((data) {

      print('------------NOTIFICACION NUEVA -------------');
      print(data);


      navigatorKey.currentState.pushNamed('driver/travel/request', arguments: data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tyvo",
      navigatorKey: navigatorKey,
      initialRoute: "Splash",
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: AppBarTheme(
            elevation: 0
        ),
        primaryColor: blackColors,
      ),
      routes: {
        'client/travel/type/request' : (BuildContext context) => ClientTravelTypeRequestPage(),
        'image': (BuildContext context) => ImgPage(),
        'ClientCupons': (BuildContext context) => ClientCupons(),
        'register/code': (BuildContext context) => CodeAdminPage(),
        'driver/register/cotizacion/taximetroxpuntos': (BuildContext context) => DriverRegisterCotizacionTaximetroXPuntosPage(),
        'driver/register/cotizacion': (BuildContext context) => DriverRegisterCotTaximetroPage(),
        'driver/map/cotizacion/info' : (BuildContext context) => DriverTravelInfoPage(),
        'driver/map/cotizacion': (BuildContext context) => DriveMapPageCotizacion(),
        'driver/map/cotizacion/travel': (BuildContext context) => DriverTravelMapTaximetroPage(),
        'admin/delete/driver': (BuildContext context) => DeleteDriverPage(),
        'admin/list/driver': (BuildContext context) => ListDriverPage(),
        'admin/delete/admin': (BuildContext context) => DeleteAdminPage(),
        'admin/list/admin':(BuildContext context) => ListAdminPage(),
        'admin/register/cupon': (BuildContext context) => CuponsRegister(),
        'Tarifa' : (BuildContext context) => TarifaAdminPage(),
        'HistorialAgendaDetail': (BuildContext context)=> HistorialAgendaDetail(),
        'driver/agenda': (BuildContext context) => HistorialAgendaPage(),
        'Splash' : (BuildContext context) => SplashPage(),
        'SplashDriver': (BuildContext context) => SplashPageDriver(),
        'SplashAdmin': (BuildContext context) => SplashPageAdmin(),
        'loginAdmin' : (BuildContext context) => LoginPageAdmin(),
        "loginClient" : (BuildContext context) => LoginClient(),
        "client_register" : (BuildContext context) => ClientRegisterPage(),
        "driver_register" : (BuildContext context) => DriverRegisterPage(),
        "driver/map" : (BuildContext context) => DriverMapPage(),
        "Menu" : (BuildContext context) => MenuAdmin(),
        "driverhistorydetail" : (BuildContext context) => DriverHistoryDetailPage(),
        "RegisterDriver" : (BuildContext context) => RegPageDriver(),
        "RegisterAdmin" : (BuildContext context) => RegPageAdmin(),
        "driverhistory":(BuildContext context) => DriverHistoryPage(),
        "driver/travel/request" : (BuildContext context) => DriverTravelRequestPage(),
        'driver/travel/map' : (BuildContext context) => DriverTravelMapPage(),
        'driver/travel/calification' : (BuildContext context) => DriverTravelCalificationPage(),
        'driver/edit' : (BuildContext context) => DriverEditPage(),
        "client/map" : (BuildContext context) => ClientMapPage(),
        "client/travel/info" : (BuildContext context) => ClientTravelInfoPage(),
        "client/travel/request" : (BuildContext context) => ClientTravelRequestPage(),
        'client/travel/map' : (BuildContext context) => ClientTravelMapPage(),
        'client/travel/calification' : (BuildContext context) => ClientTravelCalificationPage(),
        'client/edit' : (BuildContext context) => ClientEditPage(),
        'client/history' : (BuildContext context) => ClientHistoryPage(),
        'client/history/detail' : (BuildContext context) => ClientHistoryDetailPage(),
      },
    );


}}
