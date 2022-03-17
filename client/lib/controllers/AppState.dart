import 'package:client/api/v1/UploadMediaQueue.dart';
import 'package:get/get.dart';

class AppState extends GetxController {
  var pageIndex = 0.obs;
  UploadMediaQueue uploader = UploadMediaQueue(groupID: "622e80202d9894fe032c4eac");
}
