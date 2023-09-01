import 'dart:async';

import 'package:bn_sl/services/customer_service/customer.dart';
import 'package:bn_sl/widgets/components.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'models/customer_response.dart';

class CustomersLocation extends StatefulWidget {
  const CustomersLocation({super.key});

  @override
  State<CustomersLocation> createState() => _CustomersLocationState();
}
List latlongs=[
  // LatLng(-33.865143, 151.209900),
  LatLng(36.181113, 44.109167),
  LatLng(36.191113, 44.109167),
  LatLng(36.171113, 44.109167),
  LatLng(36.181113, 44.109167),
  LatLng(36.191113, 44.109167),
  LatLng(36.171113, 44.109167),
  LatLng(36.181113, 44.109167),
  LatLng(36.191113, 44.109167),
  LatLng(36.171113, 44.109167),
  // LatLng(36.171113, 89.109167),
];
Map<String, LatLng> eve={};
LatLng center = LatLng(36.181113, 44.109167);
bool newDestination=false;
// double oldLat=0;
// double oldLong=0;
double newLat=0;
double newLong=0;
List<CustomerResponse>? customerList=[];
late int custIndex=0;


class _CustomersLocationState extends State<CustomersLocation> with TickerProviderStateMixin{
  late StreamSubscription<Position> _positionStream;
  void locationHereIs() async {
    await locationServicesStatus();
    await checkLocationPermissions();
  }

  Future<void> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('Current Location Permission Status = $permission.');
  }

  void checkLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> locationServicesStatus() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print(
        'Currently, the emulator\'s Location Services Status = $isLocationServiceEnabled.');
  }
  double currentLat=0;
  double currentLong=0;
  void checkCurrentLocation(){
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        distanceFilter: 1,
      ),
    )
        .listen((position) {
          print(position.latitude);
          print(position.longitude);
          setState(() {
            currentLat= position.latitude;
            currentLong= position.longitude;
          });
    });
  }
  customers() {
    (() async {
      print("-------------------");
      Customer customer = new Customer();
      customerList = await customer.Get();
      setState(() {
        //
      });
      print("---------------------");
    })();
  }
  late final _animatedMapController = AnimatedMapController(vsync: this);
  List<String>? l;
  Future<List<String>?> allLocations() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys= prefs.getKeys();
    Future<List<String>?> readLatLong() async {
      print(prefs.getKeys());
      List<String>? items;
      for(int i=0; i<keys.length; i++){
        print(prefs.getStringList("${keys.elementAt(i)}"));
        items = prefs.getStringList("${keys.elementAt(i)}");
        eve.addAll({keys.elementAt(i):LatLng(double.parse(items![0]), double.parse(items![1]))});
        latlongs.add(LatLng(double.parse(items![0]), double.parse(items![1])));
      }
      return items;
    }
    setState(() {
      //
    });
    l= await readLatLong();
    return l;
  }
  @override
  void initState() {
    super.initState();
    (() async {
      allLocations();
      locationHereIs();
      checkCurrentLocation();
      customers();
      print(latlongs);
      print(eve);
    })();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _animatedMapController,
                options: MapOptions(
                  center: center,
                  zoom: 10,
                  rotation: 90,
                  maxZoom: 18,
                  minZoom: 11,
                  onTap: newDestination==true?(tapPosition, latlong){
                    print(latlong);
                    print(tapPosition.global);
                    // print(newLat);
                    // print(newLong);
                    newLat=latlong.latitude;
                    newLong=latlong.longitude;
                    print(newLat);
                    print(newLong);
                    print(custIndex);
                    // showDialog(
                    //     context: context,
                        // builder: (BuildContext contex) {
                        //   return StatefulBuilder(
                        //     builder: (context, setState) {
                        //       return RotatedBox(
                        //         quarterTurns: 45,
                        //         child: cofirmationCustomAlertDialog(
                        //           FaIcon(FontAwesomeIcons.checkDouble, size: 60, color: btnColor,),
                        //           // Icon(Icons.error_rounded, size: 80, color: Color(0xffF04372),),
                        //           "Update location", "Do you really want to update\nthe location of ${customerList?[custIndex].name}?", "Cancel", "Proceed", context, () {
                                  // saveLocation;
                                  (() async {
                                    String key='${customerList?[custIndex].name}';
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    if(prefs.containsKey(key)){
                                      prefs.remove(key);
                                    }
                                    saveLatLong(String lat, String long) async {
                                      await prefs.setStringList(key, <String>[lat, long]);
                                    }
                                    setState(() {
                                      saveLatLong("${newLat}", "${newLong}");
                                      // if(eve.containsKey(key)) {
                                      //   eve.update(key, (value) =>
                                      //       LatLng(newLat, newLong));
                                      // }else {
                                      //   eve.addAll(
                                      //       {key: LatLng(newLat, newLong)});
                                      //   latlongs.add(LatLng(newLat, newLong));
                                      // }
                                      // if(prefs.containsKey(key)){ //latlongs.contains(LatLng(oldLat, oldLong))
                                      //   latlongs[latlongs.indexOf(LatLng(oldLat, oldLong))]= LatLng(newLat, newLong);
                                      // }else{
                                      //   latlongs.add(LatLng(newLat, newLong));
                                      //   oldLat= newLat;
                                      //   oldLong= newLong;
                                      // }
                                      latlongs=[];
                                      allLocations();
                                    });
                                    // Future<List<String>?> readLatLong() async {
                                    //   print(prefs.getKeys());
                                    //   for(int i=0; i<keys.length; i++){
                                    //     print(prefs.getStringList("${keys.elementAt(i)}"));
                                    //   }
                                    //   final List<String>? items = prefs.getStringList(key);
                                    //   return items;
                                    // }
                                  })();
                        //           Navigator.of(context, rootNavigator: true).pop();
                        //         },(){
                        //           Navigator.of(context, rootNavigator: true).pop();
                        //         },
                        //         ),
                        //       );
                        //     }
                        //   );
                        // });
                    setState(() {
                      newDestination=false;
                    });
                  }:null,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: List.generate(latlongs.length, (index) {
                      return Marker(
                        width: 80,
                        height: 80,
                        point:  latlongs[index],
                        builder: (ctx) => GestureDetector(
                          onTap: () => _animatedMapController.animateTo(
                            dest: latlongs[index],
                            zoom: 16,
                            curve: Curves.easeInOut,
                          ),
                            child: Column(
                              children: [
                                _animatedMapController.zoom>=12?Text("${eve.keys.firstWhere((element) => eve[element]==latlongs[index], orElse: ()=> "NO")}"):Container(),
                                FaIcon(FontAwesomeIcons.locationDot, size: 30, color: Colors.green,),
                              ],
                            )),
                      );
                    }),
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(currentLat, currentLong),
                        builder: (BuildContext context) {
                          return Container(
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade200,
                                      borderRadius: BorderRadius.all(Radius.circular(50),),
                                    ),
                                  ).animate( onComplete: (controller)=> controller.loop(reverse: true)).scale(curve: Curves.easeOut, duration: 2.seconds),
                                ), //.tint(color: Colors.green.withOpacity(0.5), duration: 2.seconds, curve: Curves.easeInOut),
                                Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(Radius.circular(50),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              newDestination?Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      newDestination=false;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffF04372),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 3,
                          spreadRadius: 1,
                          offset: const Offset(-2, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(child: FaIcon(FontAwesomeIcons.xmark, color: Colors.white, size: 25,)),
                  ),
                ),
              ):Container(),
              GestureDetector(
                onTap: () => currentLat!=0 && currentLong!=0?_animatedMapController.animateTo(
                  dest: LatLng(currentLat, currentLong),
                  zoom: 16,
                  curve: Curves.easeInOut,
                ):null,
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: const Offset(-2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(Icons.my_location_rounded, size: 25, color: Colors.black54,),
                ),
              ),
              buildBottomDrawer(context, Container(
                // width: 150,
                // height: 380,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    FaIcon(FontAwesomeIcons.minus, color: Colors.grey, size: 35,),
                    Flexible(
                      child: Container(
                        // color: Colors.redAccent,
                        width: double.infinity,
                        height: 480,
                        // padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(customerList!.length, (index){
                              return GestureDetector(
                                  // eve.containsKey(customerList?[index].name)
                                onTap: () {
                                  eve.containsKey(customerList?[index].name)?_animatedMapController.animateTo(
                                  dest: eve.containsKey(customerList?[index].name)?eve[customerList?[index].name]:null,
                                  zoom: 16,
                                  curve: Curves.easeInOut,
                                ):null;
                                  custIndex=index;
                                  },
                                child: Container(
                                  width: 60,
                                  height: 480,
                                  margin: index==0?EdgeInsets.fromLTRB(10, 10, 10, 10):EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.35),
                                    //     blurRadius: 3,
                                    //     spreadRadius: 1,
                                    //     offset: const Offset(-2, 2), // changes position of shadow
                                    //   ),
                                    // ],
                                  ),
                                  // margin: EdgeInsets.only(left: 10,),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            newDestination=true;
                                            custIndex=index;
                                            // if(eve[customerList?[index].name]?.latitude!=null) {
                                            //   oldLat = eve[customerList?[index].name]!.latitude;
                                            //   oldLong = eve[customerList?[index].name]!.longitude;
                                            // }else{
                                            //   oldLat=0;
                                            //   oldLong=0;
                                            // }
                                          });
                                          print("edit");
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: btnColor,
                                          ),
                                          child: Center(
                                            child: RotatedBox(
                                                quarterTurns: 45,
                                                child: Icon(eve.containsKey(customerList?[index].name)?Icons.edit_location_alt_rounded:Icons.add_location_alt_rounded, color: Colors.white, size: 15,)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          RotatedBox(
                                              quarterTurns: 45,
                                        // customerList?.firstWhere((e) => e.name==val)
                                        // ${latlongs[keyS.indexOf(keyS.firstWhere((element) => element==customerList?[index].name, orElse: () => "0"))!=-1?keyS.indexOf(keyS.firstWhere((element) => element==customerList?[index].name, orElse: () => "0")):0]}
                                              child: Text("${eve.containsKey(customerList?[index].name)?"${eve[customerList?[index].name]?.latitude.toStringAsFixed(6)}, ${eve[customerList?[index].name]?.longitude.toStringAsFixed(6)}":"Not Specified!"}", style: TextStyle(color: Colors.grey, fontSize: 8),)
                                          ),
                                          RotatedBox(
                                            quarterTurns: 45,
                                            child: Text("${customerList?[index].name}", style: TextStyle(color: Colors.black87, fontSize: 15),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), BottomDrawerController()),
            ],
          ),
        ),
      ),
    );
  }
}
