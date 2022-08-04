import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTrackingScreen extends StatefulWidget {
  static String routeName = "/map-running";
  const MapTrackingScreen({ Key? key }) : super(key: key);

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  late GoogleMapController mapController;
  Position? currentLocation;
  Set<Polyline> polyline = {};
  List<LatLng> route = [];
  bool started = false;

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 3)).listen((event) {
      // print("${event.latitude}, ${event.longitude}");
      LatLng loc = LatLng(event.latitude, event.longitude);
      route.add(loc);
      polyline.add(Polyline(
        polylineId: PolylineId(event.toString()),
        visible: true,
        points: route,
        width: 5,
        color: Colors.red,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap
      ));
      setState(() {});
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 
    _animateToUserLoc();
    currentLocation = await Geolocator.getCurrentPosition();
    return currentLocation!;
  }
  
  _animateToUserLoc() async {
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print(pos.latitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 16)));
  }

  @override
  void initState() {
    _determinePosition().then((value) => print(value)).catchError((e) => print(e));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {_animateToUserLoc();}),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(37.42796133580664,-122.085749655962), zoom: 11),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            polylines: polyline,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 60),
                  // ElevatedButton(
                  //   onPressed: () { (!started) ? {print("resetTimer()")} : {print("lapRun()")}; },
                  //   child: Container(child: Text((!started) ? "Reset" : "Lap", style: const TextStyle(color: Color(0xff212529), fontWeight: FontWeight.w500, fontSize: 14)), width: 60, height: 60, alignment: Alignment.center),
                  //   style: ElevatedButton.styleFrom(
                  //     primary: const Color(0xffF8F9FA),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(60),
                  //       side: const BorderSide(width: 3, color: Color(0xff212529)),
                  //     ),
                  //     padding: EdgeInsets.zero,
                  //     minimumSize: Size.zero,
                  //   ), 
                  // ),
                  const SizedBox(width: 60),
                  // ElevatedButton(
                  //   onPressed: () { (!started) ? {print("startTimer()")} : {print("stopTimer()")}; },
                  //   child: Container(child: (!started) ? const Text("Start", style: TextStyle(color: Color(0xff212529), fontWeight: FontWeight.w500, fontSize: 18)) : const Icon(Icons.pause), width: 60, height: 60, alignment: Alignment.center),
                  //   style: ElevatedButton.styleFrom(
                  //     primary: const Color(0xffF8F9FA),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(60),
                  //       side: const BorderSide(width: 3, color: Color(0xff212529)),
                  //     ),
                  //     padding: const EdgeInsets.all(10)
                  //   ), 
                  // ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: ElevatedButton(
                      onPressed: () { Navigator.pop(context); },
                      child: Container(child: const Icon(Icons.pin_drop, color: Color(0xffF8F9FA), size: 36), width: 60, height: 60, alignment: Alignment.center),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff212529),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero
                      ), 
                    )
                  )
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}