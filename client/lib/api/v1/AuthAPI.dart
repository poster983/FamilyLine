import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
var settings = Hive.box('settings');
var auth = Hive.box('auth');
String? refreshToken;
String? accessToken;
bool _remember = true;
/// 
Future<String> loginWithEmailPassword({required String email, required String password, bool remember=true}) async {
  _remember = remember;
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  var res = await http.post(Uri.parse(serverUrl+"/apiv1/auth/login"), body: {'email': email, 'password': password});
  Map<String, dynamic> tokens = jsonDecode(res.body);
  if(_remember) {
    auth.put('refreshToken', tokens['refreshToken']);
  } else {
    refreshToken = tokens['refreshToken'];
  }
  
  return tokens['refreshToken'];
}

String? getRefreshToken() {
  final jwt = auth.get("refreshToken", defaultValue: refreshToken);
  if(jwt == null) {
    return null;
  }
  if(JwtDecoder.isExpired(jwt)) {
    return null;
  }
 return jwt;
}
//returns null if the refresh token is invalid or hasn't been set yet
Future<String?> exchangeRefreshToken() async {
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  final rft = getRefreshToken();
  if(rft == null) {
    return null;
  }
  var res = await http.post(Uri.parse(serverUrl+"/apiv1/auth/exchange"), body: {'refreshToken': rft});
  Map<String, dynamic> tokens = jsonDecode(res.body);
  if(_remember) {
    auth.put('refreshToken', tokens['refreshToken']);
    auth.put('accessToken', tokens['accessToken']);
  } else { //store tokens in memory
    accessToken = tokens['accessToken'];
    refreshToken = tokens['refreshToken'];
  }
  
  return tokens['accessToken'];
} 

///Gets the current access token 
///returns null if it is invalid or not set.
String? getAccessToken() {
  final jwt = auth.get("accessToken", defaultValue: accessToken);
  if(jwt == null) {
    return null;
  }
  if(JwtDecoder.isExpired(jwt)) {
    return null;
  }
 return jwt;
}