import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? lat;
  double? long;

  @override
  void initState() {
    cekLatLon();
    super.initState();
  }

  cekLatLon() async {
    final prefs = await SharedPreferences.getInstance();
    var lt = prefs.getDouble("lat");
    var lg = prefs.getDouble("long");
    if (lt != null || lg != null) {
      setState(() {
        lat = lt!;
        long = lg!;
      });
    } else {
      setState(() {
        lat = -7.8164257;
        long = 112.0623391;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Map"),
          centerTitle: true,
        ),
        body: OpenStreetMapSearchAndPick(
            center: LatLong(lat!, long!),
            buttonColor: Colors.blue,
            buttonText: 'Set Current Location',
            onPicked: (pickedData) async {
              var lt = pickedData.latLong.latitude;
              var lg = pickedData.latLong.longitude;
              final prefs = await SharedPreferences.getInstance();

              await prefs.setDouble('lat', lt);
              await prefs.setDouble('long', lg);

              setState(() {
                lat = lt;
                long = lg;
              });

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Berhasil menyimpan lokasi"),
              ));
            }));
  }
}
