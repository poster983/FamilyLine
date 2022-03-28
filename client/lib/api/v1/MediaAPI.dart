import 'dart:convert';

import 'package:client/api/v1/APIUtils.dart';
import 'package:client/api/v1/AuthAPI.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'types/APIException.dart';
import 'types/APIPagination.dart';
import 'types/DBMedia.dart';
var settings = Hive.box('settings');


///Get Media data from db (paginated)
///groupID - the group to get from
///
///page - the page to find 
///
///filter - the mongodb syntax to filter by
///
///sort - the mongodb syntax to sort by
Future<Map<String, dynamic>> listMedia({required String groupID, int page=1, int limit=10, Map<String, dynamic>? filter, Map<String, dynamic>? sort}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();

  Map<String, dynamic> queryMap = {
    'page': page,
    'limit': limit
  };

  
  if(filter!= null) {
    queryMap['filter'] = json.encode(filter);
    
  }
  if(sort!= null) {
    queryMap['sort'] = json.encode(sort);
        
  }
  
  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media?" + queryFromMap(queryMap));
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(jsonDecode(res.body)['message']);
  }

  return jsonDecode(res.body);
}

///Get Media data from db (paginated)
///Saves the results to isar for offline caching
///
///groupID - the group to get from
///
///page - the page to find 
///
///filter - the mongodb syntax to filter by
///
///sort - the mongodb syntax to sort by
Future<APIPagination<DBMedia>> listMediaFromServer({required String groupID, int page=1, int limit=10, Map<String, dynamic>? filter, Map<String, dynamic>? sort}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();

  Map<String, dynamic> queryMap = {
    'page': page,
    'limit': limit
  };

  
  if(filter!= null) {
    queryMap['filter'] = json.encode(filter);
    
  }
  if(sort!= null) {
    queryMap['sort'] = json.encode(sort);
        
  }
  
  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media?" + queryFromMap(queryMap));
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw APIException(message: jsonDecode(res.body)['message'] ?? "No Error Message", statusCode: res.statusCode);
  }

  try {
    //APIPagination<DBMedia>.fromJson(json, (json) => DBMedia.fromJson(jsonDecode(json)))
    // print(jsonDecode(res.body)['docs'][0]);
    // print(DBMedia.fromJson(jsonDecode(res.body)['docs'][0]));
    //print(jsonDecode(res.body));
    APIPagination<DBMedia> response = APIPagination<DBMedia>.fromJson(jsonDecode(res.body), (data) => DBMedia.fromJson(data as Map<String, dynamic>));
    
    
    
    return response;
  } catch(e) {
    //print(jsonDecode(res.body));
    print(e);
    //rethrow;
    throw APIException(message: "Malformed response.  Could not Parse.", statusCode: res.statusCode);
  }

  return jsonDecode(res.body);
}


/// Gets a single media object by its ID From server and then from cache if offline
Future<DBMedia> getMediaByID({required String groupID, required String mediaID}) async {
  return getMediaByIDFromServer(groupID: groupID, mediaID: mediaID);
}

///Gets Media from server by ID
Future<DBMedia> getMediaByIDFromServer({required String groupID, required String mediaID}) async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  String accessToken = await refreshAndGetAccessToken();

  Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID + "/media/"+mediaID);
  var res = await http.get(url, headers: {'Authorization': 'Bearer ' + accessToken});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw APIException(message: jsonDecode(res.body)['message'] ?? "No Error Message", statusCode: res.statusCode);
  }

  try {
    return DBMedia.fromJson(jsonDecode(res.body));
  } catch(e) {
    //print(jsonDecode(res.body));
    print(e);
    //rethrow;
    throw APIException(message: "Malformed response.  Could not Parse.", statusCode: res.statusCode);
  }
}


