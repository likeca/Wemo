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
  int _counter = 0;

  // Future<List<Map>> _devices = OperateWeMo().fetchWeMos();
  // @override
  // void initState() {
  //   super.initState();
  //   OperateWeMo().fetchWeMos();
  //   // devices = OperateWeMo().fetchWeMos();
  //   // print(devices);
  // }

  // getAllDevices() {
  //   for (int i = 2; i < 10; i++) {
  //     print(i);
  //     // operationWemo(devices[i], 'get_name').then((name) {
  //     //   devices[i]['name'] = name;
  //     // });

  //     // final name = await operationWemo(devices[i], 'get_name');
  //     // devices[i]['name'] = name;
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   for (var i = 2; i < 10; i++) {
  //     var device = {};
  //     device['ip'] = '192.168.1.10$i';
  //     // String deviceName = await operationWemo(device['ip'], 'get_name');
  //     device['name'] = operationWemo(device['ip'], 'get_name');
  //     devices.add(device);
  //   }
  //   getAllDevices();
  //   print(devices);
  // }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<List<Map>> _devices = WeMoRequest().fetchItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost()));
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: FutureBuilder<List<Map>>(
        future: _devices,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }
          //Has data arrived
          if (snapshot.hasData) {
            List<Map> posts = snapshot.data;

            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Map thisItem = posts[index];
                  return ListTile(
                    title: Text('${thisItem['state']}'),
                    // subtitle: Text('${thisItem['body']}'),
                    // onTap: () {
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetails(thisItem['id'].toString())));
                    // },
                  );
                });
          }

          //Display a loader
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text(widget.title),
//         title: const Text('WeMo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         // onPressed: () => operationWemo('192.168.1.102', 'get_state'),
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
}
