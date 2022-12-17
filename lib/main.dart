import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'custom_dialog_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, double>> myVisitList = [];

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late GoogleMapController mapController;
  static const Color randomButtonColor = Color(0xFF2EC1EF);
  static const Color homeButtonColor = Color(0xFF9A2EEF);
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  BitmapDescriptor? customIcon;
  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(45.521563, -122.677433),
    zoom: 11.0,
  );
  void _onMapCreated(GoogleMapController cnTlr) {
    _controller.complete(cnTlr);
  }
  @override
  void initState() {
    // TODO: implement initState
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(30, 30)), 'images/map_marker.png')
        .then((d) {
      customIcon = d;
    });

    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:  Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: initialPosition,
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(),
              color: Colors.transparent,
            ),
            child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: addRandomLocation,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: randomButtonColor),
                        child: const Center(
                            child: Text(
                              'Teleport me to somewhere\nrandom',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto",
                                  fontSize: 18),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: goToOriginalLocation,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 65,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: homeButtonColor),
                        child: const Center(
                            child: Text(
                              'Bring me back home',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Roboto",
                                  fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  BoxDecoration basicGreenButtonShape(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    );
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        showToastr("Location Service is not enabled in this device.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showToastr("Sorry, permission is not granted.");
        return;
      }
    }

    locationData = await location.getLocation();
    print('${locationData.latitude} - ${locationData.longitude}');
    moveMap(locationData.latitude!, locationData.longitude!);

  }

  void showToastr(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void addRandomLocation() {
    final random = Random();
    double randomLat = -90 + random.nextDouble() * 90 * 2;
    double randomLng = -180 + random.nextDouble() * 180 * 2;
    print('$randomLat, $randomLng');
    moveMap(randomLat, randomLng);
  }

  void moveMap(double latitude, double longitude) async {

    final int markerCount = markers.length;
    final String markerIdVal =
        'marker_id_${markerCount}_${latitude}_${longitude}';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          latitude,
          longitude,
        ),
        icon: customIcon!
        // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
        );

    final GoogleMapController controller = await _controller.future;
    // print('${l.latitude} - ${l.longitude}');
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 11),
      ),
    );
    Map<String, double> locationData = {
      "latitude": latitude,
      "longitude": longitude
    };
    myVisitList.add(locationData);

    setState(() {
      myVisitList = myVisitList;
      markers[markerId] = marker;
    });
  }

  void goToOriginalLocation() async {
    Map<String, double> originalLocation = myVisitList[0];

    final GoogleMapController controller = await _controller.future;
    // print('${l.latitude} - ${l.longitude}');
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                originalLocation["latitude"]!, originalLocation["longitude"]!),
            zoom: 11),
      ),
    );
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) =>
              CustomDialogBox(visitList: myVisitList),
          opaque: false),
    );

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //
    //       return CustomDialogBox(
    //         title: "Custom Dialog Demo",
    //         descriptions:
    //             "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
    //         text: "Yes",
    //       );
    //     });
  }
}
