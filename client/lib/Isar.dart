  //setup isar
import 'package:client/api/v1/types/DBMedia.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Isar? isar;
Future<void> setupIsar() async {
  String? dir;
  if(!kIsWeb) {
    var temp = await getApplicationSupportDirectory();
    dir = temp.path;
  }

  isar = await Isar.open(
    schemas: [DBMediaSchema],
    directory: dir,
    inspector: kDebugMode && !kIsWeb,
  );
}


Isar getIsar() {
  try{
    return isar!;
  } catch(e) {
    throw Exception("Isar not initialized");
  }
  
}