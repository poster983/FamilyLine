
import 'dart:convert';

import 'package:client/api/v1/AuthAPI.dart';
import 'package:queue/queue.dart' as FutureQueue;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;


class UploadMediaQueue {
  final queue = FutureQueue.Queue(parallel: 5);
  String? groupID;
  UploadMediaQueue({this.groupID});

  queueUpload({required String filename, required Stream<List<int>> fileStream}) {
    queue.add(() async {
      await _uploadMedia(filename: filename, fileStream: fileStream);
    });
  }

  Future<void> _uploadMedia({required String filename, required Stream<List<int>> fileStream}) async  {
    if(groupID == null) {
      throw Exception("groupID Required to be set in class");
    }
    String serverUrl = settings.get('server', defaultValue: "http://localhost:3000");
    String accessToken = await refreshAndGetAccessToken();
    Uri url = Uri.parse(serverUrl+"/apiv1/group/" + groupID! + "/media/");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({'Authorization': 'Bearer ' + accessToken});
    var fileLength = await fileStream.length;
    
    request.files.add(
      http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: filename
      )
    );

    var res = await request.send();
    if(res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("failed To Upload.  Code: " + res.statusCode.toString());
    }

    //return jsonDecode(res.body);
  }
  
}