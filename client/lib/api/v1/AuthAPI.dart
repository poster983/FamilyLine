import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
var settings = Hive.box('settings');
var auth = Hive.box('auth');
String? refreshToken;
String? accessToken;
bool _remember = true;

///Thrown when the user needs to relogin
class RequireLogin implements Exception {
  String errorMessage() {
    return ("Need to login again");
  }
}

/// 
Future<String> loginWithEmailPassword({required String email, required String password, bool remember=true}) async {
  _remember = remember;
  String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
  try {
    var res = await http.post(Uri.parse(serverUrl+"/apiv1/auth/login"), body: {'email': email, 'password': password});
    if(res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }
    //print(res.reasonPhrase);
    Map<String, dynamic> tokens = jsonDecode(res.body);
    if(_remember) {
      auth.put('refreshToken', tokens['refreshToken']);
    } else {
      refreshToken = tokens['refreshToken'];
    }
    
    return tokens['refreshToken'];
  } on Exception catch (exception) { 
    print("exc");
    print(exception);
    rethrow;
    } catch(e) {
    print(e);
    rethrow;
  }
  
}

String? getRefreshToken() {
  String? jwt;
  if(_remember) {
    jwt = auth.get("refreshToken", defaultValue: refreshToken);
  } else {
    jwt =refreshToken;
  }
   
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
  print({'refreshToken': rft});
  var res = await http.post(Uri.parse(serverUrl+"/apiv1/auth/exchange"), body: {'refreshToken': rft});
  if(res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(jsonDecode(res.body)['message']);
  }
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
  String? jwt;
  if(_remember) {
    jwt = auth.get("accessToken", defaultValue: accessToken);
  } else {
    jwt =accessToken;
  }
  
  if(jwt == null) {
    return null;
  }
  if(JwtDecoder.isExpired(jwt)) {
    return null;
  }
 return jwt;
}


/// Logs the user out 
Future<bool> logout() async{
  //in the future also delete the refresh token
  if(_remember) {
    auth.put("accessToken", null);
    auth.put("refreshToken", null);
  } else {
    refreshToken = null;
    accessToken = null;
  }

  return true;
}


/// Will automaticly refresh the access token if expired
Future<String> refreshAndGetAccessToken() async {
  var accessToken = getAccessToken();
  if(accessToken == null) { //may be invalid. try and exchange
    try{ 
        print("EXCHANGEW PLEASE");
        accessToken = await exchangeRefreshToken();
        if(accessToken == null) {
          throw RequireLogin();
        }
    } catch(e) {
      print(e);
      throw RequireLogin();
    }
    
  }

  return accessToken;
}