// ignore_for_file: empty_catches

import 'package:http/http.dart' as http;

class WeMoRequest {
  Future<Map> operateWeMo(String ip, String cmd) async {
    Map item = {'name': '', 'switchState': 0};
    int switchState = 0;
    String operation = 'Get';
    String option = 'BinaryState';

    if (cmd == 'on') {
      operation = 'Set'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
    } else if (cmd == 'off') {
      operation = 'Set'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
    } else if (cmd == 'get_state') {
      operation = 'Get'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
    } else if (cmd == 'get_name') {
      operation = 'Get'; // Get or Set, GetBinaryState, SetBinaryState, GetSignalStrength,
      option = 'FriendlyName';
    }

    var headers = {'Accept': '*/*', 'content-type': 'text/xml; charset="utf-8"', 'SOAPACTION': '"urn:Belkin:service:basicevent:1#$operation$option"'};
    String body =
        '''
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
      String url = '$ip:49153';
      http.Response response = await http.post(Uri.http(url, '/upnp/control/basicevent1'), headers: headers, body: body).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        if (cmd == 'get_name') {
          RegExp regexp = RegExp('<$option>(.*)</$option>');
          final match = regexp.firstMatch(response.body);
          if (match?.group(1) != '') {
            item['name'] = match?.group(1);
          }
        } else {
          RegExp regexp = RegExp('<$option>(.*)</$option>');
          final match = regexp.firstMatch(response.body);
          if (match?.group(1) != '') {
            item['switchState'] = match?.group(1);
          }
        }
      }
    } catch (e) {}
    return item;
  }

  Future<List<Map>> fetchDevices() async {
    List<Map> items = [];

    for (var i = 2; i < 10; i++) {
      String ip = '192.168.1.10$i';
      var item = {};
      Map result = await operateWeMo(ip, 'get_name');
      item['name'] = result['name'];
      result = await operateWeMo(ip, 'get_state');
      item['switchState'] = result['switchState'];
      items.add(item);
    }

    return items;
  }
}
