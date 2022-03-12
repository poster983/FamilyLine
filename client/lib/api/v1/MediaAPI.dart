import 'dart:convert';

import 'package:client/api/v1/APIUtils.dart';
import 'package:client/api/v1/AuthAPI.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
var settings = Hive.box('settings');

Future<Map<String, dynamic>> listMedia({required String groupID, int page=1}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();
  Map<String, dynamic> queryMap = {
    'page': page
  };
  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media?" + queryFromMap(queryMap));
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(jsonDecode(res.body)['message']);
  }

  return jsonDecode(res.body);
}

