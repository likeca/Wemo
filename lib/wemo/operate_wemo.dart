import 'package:http/http.dart' as http;
import 'dart:convert';

class WeMoRequest {
  //--Fetching all items
  Future<List<Map>> fetchItems() async {
    List<Map> items = [];

    int switchState = 0;
    String operation = 'Get';
    String option = 'BinaryState';
    var headers = {'Accept': '*/*', 'content-type': 'text/xml; charset="utf-8"', 'SOAPACTION': '"urn:Belkin:service:basicevent:1#$operation$option"'};
    String body = '''
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <s:Body>
              <u:$operation$option xmlns:u="urn:Belkin:service:basicevent:1">
                  <$option>$switchState</$option>
              </u:$operation$option>
          </s:Body>
      </s:Envelope>
    ''';
    // print(headers);
    //--Get the data from the API
    // http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    // print(response.body);
    // if (response.statusCode == 200) {
    //   // get the data from the response
    //   String jsonString = response.body;
    //   // Convert to List<Map>
    //   List data = jsonDecode(jsonString);
    //   items = data.cast<Map>();
    // }

    for (var i = 2; i < 10; i++) {
      String url = '192.168.1.10$i:49153';
      http.Response response = await http.post(Uri.http(url, '/upnp/control/basicevent1'), headers: headers, body: body).timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        var item = {};
        RegExp regexp = RegExp(r'<BinaryState>(.*)</BinaryState>');
        final match = regexp.firstMatch(response.body);
        print(match?.group(1));
        if (match?.group(1) != '') {
          item['state'] = match?.group(1);
        }
        items.add(item);
      }
    }
    print(items);
    return items;
  }
}