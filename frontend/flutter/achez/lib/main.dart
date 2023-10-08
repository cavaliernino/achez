import 'dart:async';
import 'dart:convert';

import 'package:achez/maps.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const AchezApp());
}

class AchezApp extends StatelessWidget {
  const AchezApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achez by Panal',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AchezHomePage(title: 'Achez by Panal'),
    );
  }
}

class AchezHomePage extends StatefulWidget {
  const AchezHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AchezHomePage> createState() => _AchezHomePageState();
}

class _AchezHomePageState extends State<AchezHomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition _laPolvora = CameraPosition(
    target: LatLng(-33.0826021, -71.6209753),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _getBoundaries(CameraPosition cameraPosition) {
    // You can do whatever you want with cameraPosition here
    // send boundaries
    // get risk grid and interest points
    // risk grid element: center, hexa-radius
    // to determine risk grid: start on active fire and check wind, temp and humidity
    // higher temp: higher risk
    // 1 km extension grid in direction of high wind
    // 11 grid elements on narrower screen dim
    var decodedJsonResponse = json.decode(
        '{"active_fire_points": [{"lat": -33.0832497, "lon": -71.6208988},{"lat": -33.082151, "lon": -71.619826}],"on_foot_batallions": [{"lat": -33.077449, "lon": -71.621194}], "truck_batallions": [{"lat": -33.082249, "lon": -71.619971}],"air_support": [{"lat": -33.075563, "lon": -71.595046}],"videos": [{"lat": -33.082094, "lon": -71.624532, "src": "fire_video.mp4"},], "risk_grid": [ {"lat": 0, "lon": 0, "radius": 1},{"lat": 0, "lon": 0, "radius": 1}]}');

    List<dynamic> active_fire_points =
        decodedJsonResponse["active_fire_points"];
    List<dynamic> on_foot_batallions =
        decodedJsonResponse["on_foot_batallions"];
    List<dynamic> truck_batallions = decodedJsonResponse["truck_batallions"];
    List<dynamic> air_support = decodedJsonResponse["air_support"];
    List<dynamic> videos = decodedJsonResponse["videos"];
    List<dynamic> risk_grid = decodedJsonResponse["risk_grid"];
    /*active_fire_points.forEach((active_fire_point) {
      var _active_fire_count = 1;
      final markerId = MarkerId("active_fire_$_active_fire_count");
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          active_fire_point['lat'],
          active_fire_point['lon'],
        ),
        infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
        onTap: () => _onMarkerTapped(markerId),
        onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
        onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
      );
      _active_fire_count++;
      setState(() {
        markers[markerId] = marker;
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _laPolvora,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        //onCameraMove: _getBoundaries,
        //markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  bool _switch = true;
  Future<void> _goToTheLake() async {
    if (_switch) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    } else {
      Widget b = const MapsDemo();
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => Scaffold(
                appBar: AppBar(title: const Text("Maps examples")),
                body: b,
              )));
    }
    _switch = !_switch;
  }
/*
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the AchezHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }*/
}
