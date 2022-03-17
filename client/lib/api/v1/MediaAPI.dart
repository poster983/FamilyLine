import 'dart:convert';

import 'package:client/api/v1/APIUtils.dart';
import 'package:client/api/v1/AuthAPI.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
var settings = Hive.box('settings');


///Get Media data from db (paginated)
///groupID - the group to get from
///
///page - the page to find 
///
///filter - the mongodb syntax to filter by
Future<Map<String, dynamic>> listMedia({required String groupID, int page=1, Map<String, dynamic>? filter}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();

  Map<String, dynamic> queryMap = {
    'page': page
  };

  
  if(filter!= null) {
    queryMap['filter'] = json.encode(filter);
    
  }
  
  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media?" + queryFromMap(queryMap));
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(jsonDecode(res.body)['message']);
  }

  return jsonDecode(res.body);
}


/// Gets a single media object by its ID
Future<Map<String, dynamic>> getMediaByID({required String groupID, required String mediaID}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();

  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media/"+mediaID);
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(jsonDecode(res.body)['message']);
  }

  return jsonDecode(res.body);
}



