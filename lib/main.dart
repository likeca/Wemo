import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeMo());
}

class WeMo extends StatelessWidget {
  const WeMo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeMo',
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
  int _counter = 0;
  var devices = [];

  String switchState = '0';
  String operation = 'Get'; //  $operation$option, GetBinaryState, SetBinaryState, GetSignalStrength
  String option = 'BinaryState'; // $operation: Get or Set, $option: BinaryState, BinaryState, SignalStrength

  initWemo() {
    for (var i = 2; i < 10; i++) {
      devices.add({'ip': '192.168.1.10$i'});
    }
  }

  operationWemo(ip) async {
    String url = '$ip:49153';
    var headers = {'Accept': '*/*', 'content-type': 'text/xml; charset="utf-8"', 'SOAPACTION': '"urn:Belkin:service:basicevent:1#$operation$option"'};
    String data = '''
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <s:Body>
              <u:$operation$option xmlns:u="urn:Belkin:service:basicevent:1">
                  <$option></$option>
              </u:$operation$option>
          </s:Body>
      </s:Envelope>
    ''';

    try {
      var response = await http.post(Uri.http(url, '/upnp/control/basicevent1'), headers: headers, body: data).timeout(const Duration(seconds: 10));
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
        // onPressed: _incrementCounter,
        onPressed: () => wemo('192.168.1.102'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
