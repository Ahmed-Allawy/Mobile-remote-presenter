import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Dio dio = Dio();
  final TextEditingController ipController = TextEditingController();
  final GlobalKey formkey = GlobalKey();
  String serverIp = ""; // User will enter this
  final int serverPort = 5000;

  @override
  void initState() {
    super.initState();

    // Listen for Volume Button Presses
    // FlutterVolumeController.addListener((volume) {
    //   print("------------------------------------------------");
    //   print("volume is $volume");
    //   print("------------------------------------------------");
    //   if (volume > 0.5) {
    //     sendCommand("UP");
    //   } else {
    //     sendCommand("DOWN");
    //   }
    // });
  }

  Future<void> sendCommand(String command) async {
    if (serverIp.isEmpty) {
      print("Enter an IP address first!");
      return;
    }

    final String url = "http://$serverIp:$serverPort";
    try {
      Response response = await dio.post(url, data: command);
      print("Response: ${response.data}");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Wi-Fi Remote Control"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Form(
                      key: formkey,
                      child: TextField(
                        controller: ipController,
                        decoration: InputDecoration(
                          labelText: "Enter Device IP",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            serverIp = value.trim();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton.icon(
                  onPressed: () => sendCommand("F5"),
                  icon: Icon(Icons.fullscreen_sharp),
                  label: Text('full screen'), // Full Screen Button
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton.icon(
                  onPressed: () => sendCommand("UP"),
                  icon: Icon(Icons.arrow_upward),
                  label: Text('UP       '), // Full Screen Button
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton.icon(
                  onPressed: () => sendCommand("DOWN"),
                  icon: Icon(Icons.arrow_downward_sharp),
                  label: Text('DOWN'), // Full Screen Button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener(); // Remove volume button listener
    super.dispose();
  }
}
