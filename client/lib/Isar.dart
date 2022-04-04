  //setup isar
import 'package:client/api/v1/types/DBMedia.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Isar? isar;
Future<void> setupIsar() async {


  isar = await Isar.open(
    schemas: [DBMediaSchema],
     //directory: (kIsWeb)? await getApplicationSupportDirectory(): null,
    inspector: kDebugMode,
  );
}


Isar getIsar() {
return isar!;

}