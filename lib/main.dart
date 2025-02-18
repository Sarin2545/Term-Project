import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 243, 138, 1),
        ),
      ),
      home: const MyHomePage(title: 'Maps'),
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
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 138, 1),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ), // ทำให้ตัวหนา
            ),
            const SizedBox(width: 8), // เว้นระยะห่าง
            const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 0, 0, 0),
            ), // ไอคอนหมุดสีแดง
          ],
        ),
        centerTitle: true,
      ),
      body:
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPosition!,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentPosition!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Color.fromARGB(255, 252, 17, 0),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Dev',
        backgroundColor: const Color.fromARGB(255, 243, 138, 1),
        child: const Icon(Icons.info, color: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // ให้ขยายขนาดได้ตามเนื้อหา
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 138, 1), // พื้นหลังสีดำ
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีกับข้อมูล
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 224, 175, 114),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildListTile("Mobile Application---\nENGCE307-SEC : 1"),
                    _buildListTile("นาย สารินทร์ อินต๊ะรักษา\nรหัสนักศึกษา : 65543206082-1",),
                    _buildListTile("นาย ธีรกานต์ ฟองคำ\nรหัสนักศึกษา : 65543206063-1",),
                    _buildListTile("นาย วุฒิพงศ์ เขียวขำ\nรหัสนักศึกษา : 65543206079-7",),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ฟังก์ชันสร้าง ListTile ที่มีสไตล์สวยงาม
  Widget _buildListTile(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      width: double.infinity, // ทำให้ Container ยืดเต็มขอบจอ
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 175, 114), // สีพื้นหลัง ListTile
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text.contains(
              "Mobile Application",
            ) // ตรวจสอบข้อความว่าเป็น "Mobile Application" หรือไม่
            ? "*--- Mobile Application ---*\n*-- ENGCE307-SEC : 1 --*" // ถ้าใช่ทำให้เป็นตัวหนา
            : text,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 18,
          fontWeight:
              text.contains("Mobile Application") // ตรวจสอบข้อความ
                  ? FontWeight
                      .bold // ถ้าเป็นข้อความที่ต้องการตัวหนา
                  : FontWeight.normal, // ถ้าไม่ใช่ให้เป็นปกติ
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
