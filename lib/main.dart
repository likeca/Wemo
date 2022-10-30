import 'package:flutter/material.dart';
import 'package:wemo/wemo/operate_wemo.dart';

var devices = [];

void main() {
  runApp(const WeMo());
}

class WeMo extends StatelessWidget {
  const WeMo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeMo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'WeMo Desc'),
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
  final Future<List<Map>> _devices = WeMoRequest().fetchItems();

  void toggleWemo() {
    print('Wemo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map>>(
        future: _devices,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map> devices = snapshot.data;
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                // padding: const EdgeInsets.all(20),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 30,
                  children: <Widget>[
                    for (int i = 0; i < devices.length; i++)
                      ElevatedButton(
                        onPressed: () {
                          toggleWemo();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(25), // Set padding
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                          fixedSize: const Size(220, 60),
                        ),
                        child: Text('${devices[i]['state']}'),
                      )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
