
import 'dart:convert';

import 'package:client/api/v1/AuthAPI.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:queue/queue.dart' as FutureQueue;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

var settings = Hive.box('settings');

class UploadMediaQueue {
  final queue = FutureQueue.Queue(parallel: 5);
  String? groupID;
  UploadMediaQueue({this.groupID});

  queueUpload(PlatformFile file) {
    
    queue.add(() async {
      try {
        await _uploadMedia(file);
      } catch(e) {
        print(e.toString());
      }
      
    });
    
  }

  Future<void> _uploadMedia(PlatformFile file) async  { //Stream<List<int>> fileStream
    print("Uploading file: " + file.name);
    if(groupID == null) {
      throw Exception("groupID Required to be set in class");
    }
    
    String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
    String accessToken = await refreshAndGetAccessToken();
    
    Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID! + "/media/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({'Authorization': 'Bearer ' + accessToken});
    //var fileLength = await fileStream.length;
    //print(fileLength);
    //workarround for heic mimetype (unneded as we can infer now)
    // String mimeType = lookupMimeType(file.name) ?? "";
    // if(file.extension == "heic") {
    //   mimeType = "image/heic";
    // }
    //print(lookupMimeType("/"+file.name));
    request.files.add(
      http.MultipartFile(
        'file',
        file.readStream!,
        file.size,
        filename: file.name,
        //contentType: MediaType.parse(mimeType)
      )
    );

    
    //print(accessToken);
    var res = await request.send();
    //print(res.statusCode);
    if(res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("failed To Upload.  Code: " + res.statusCode.toString());
    }

    //return jsonDecode(res.body);
  }
  
}