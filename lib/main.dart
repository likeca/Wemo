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

  operationWemo(ip, cmd) async {
    print(ip);
    String url = '$ip:49153';
    int switchState = 0;
    String operation = '';
    String option = '';

    if (cmd == 'on') {
      switchState = 1; // 1: ON, 0: OFF
      operation = 'Set'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
      option = 'BinaryState';
    }
    if (cmd == 'off') {
      switchState = 0; // 1: ON, 0: OFF
      operation = 'Set'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
      option = 'BinaryState';
    }
    if (cmd == 'get_state') {
      switchState = 0; // 1: ON, 0: OFF
      operation = 'Get'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
      option = 'BinaryState';
    }
    if (cmd == 'get_name') {
      switchState = 0; // 1: ON, 0: OFF
      operation = 'Get'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
      option = 'FriendlyName';
    }

    var headers = {'Accept': '*/*', 'content-type': 'text/xml; charset="utf-8"', 'SOAPACTION': '"urn:Belkin:service:basicevent:1#$operation$option"'};
    String data = '''
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <s:Body>
              <u:$operation$option xmlns:u="urn:Belkin:service:basicevent:1">
                  <$option>$switchState</$option>
              </u:$operation$option>
          </s:Body>
      </s:Envelope>
    ''';

    try {
      var response = await http.post(Uri.http(url, '/upnp/control/basicevent1'), headers: headers, body: data).timeout(const Duration(seconds: 1));

      if (cmd == 'get_name') {
        RegExp regexp = RegExp(r'<FriendlyName>(.*)</FriendlyName>');
        final match = regexp.firstMatch(response.body);
        print(match?.group(1));
        if (match?.group(1) != '') {
          return match?.group(1);
        }
      } else {
        RegExp regexp = RegExp(r'<BinaryState>(.*)</BinaryState>');
        final match = regexp.firstMatch(response.body);
        print(match?.group(1));
        if (match?.group(1) != '') {
          return match?.group(1);
        }
      }
    } catch (e) {
      return 'Offline Line';
    }
  }

  @override
  void initState() {
    super.initState();
    for (var i = 2; i < 10; i++) {
      var device = {};
      device['ip'] = '192.168.1.10$i';
      device['name'] = operationWemo(device['ip'], 'get_name');
      devices.add(device);
    }
    // getAllDevices();
    print(devices);
  }

  getAllDevices() {
    for (int i = 2; i < 10; i++) {
      print(i);
      // operationWemo(devices[i], 'get_name');
      // final name = operationWemo(devices[i], 'get_name');
      // devices[i]['name'] = name;
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
        onPressed: () => operationWemo('192.168.1.102', 'get_state'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
