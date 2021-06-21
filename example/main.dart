import 'package:flutter/material.dart';
import 'package:slider_switch/slider_switch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SliderSwitch(
                  isEnabled: false, // disable the button
                  // initialStatus: true,
                  // width: 50.0,
                  // lenght: 120.0,
                  // orientation: Axis.horizontal,
                  statusColorOpacity: 0.7,
                  onChanged: (bool value) => print("new listen value $value"),
                ),
                SliderSwitch(
                  // initialStatus: true, // default: false (false|true)
                  // width: 50.0,
                  // lenght: 120.0,
                  // orientation: Axis.horizontal, // default: Axis.vertical (Axis.vertical|Axis.horizontal)
                  statusColorOpacity: 0.7, // default 0.5
                  onChanged: (bool value) => print("new speaking value $value"),
                  statusOnIcon:
                      Icons.record_voice_over, // default: Icons.volume_up
                  statusOffIcon:
                      Icons.voice_over_off, // default: Icons.volume_off
                  statusOnColor: Colors.red, // default: Color.green
                ),
              ],
            ),
            SliderSwitch(
              // status: true,
              // width: 50.0,
              // lenght: 120.0,
              orientation: Axis.horizontal,
              statusColorOpacity: 0.7,
              onChanged: (bool value) => print("new listen value $value"),
            ),
            SliderSwitch(
              // initialStatus: true, // default: false (false|true)
              // width: 50.0,
              // lenght: 120.0,
              orientation: Axis
                  .horizontal, // default: Axis.vertical (Axis.vertical|Axis.horizontal)
              statusColorOpacity: 0.7, // default 0.5
              onChanged: (bool value) => print("new speaking value $value"),
              statusOnIcon: Icons.record_voice_over, // default: Icons.volume_up
              statusOffIcon: Icons.voice_over_off, // default: Icons.volume_off
              statusOnColor: Colors.red, // default: Color.green
            ),
          ],
        ),
      ),
    );
  }
}
