
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void popAllPages(BuildContext context) {
  while(true) {
    try {
      context.pop();
    } catch(e) {
      break;
    }
    
  }
}


Future<FilePickerResult?> showUploadUI(BuildContext context) async {
  var allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'heic'];
  FilePickerResult? result;
  if(Platform.isIOS){
    await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Upload files'),
          message: const Text('Select Source'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Files App'),
              onPressed: () async{
                result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: true, 
                    allowCompression: false, 
                    allowedExtensions: allowedExtensions,
                    withData: false,
                    withReadStream: true,

                );
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Camera Roll'),
              onPressed: () async {
                result = await FilePicker.platform.pickFiles(
                    type: FileType.media,
                    allowMultiple: true, 
                    allowCompression: true, 
                    withData: false,
                    withReadStream: true,

                    //allowedExtensions: allowedExtensions
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      );

  } else {
   result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true, 
        allowCompression: false, 
        allowedExtensions: allowedExtensions,
        withData: false,
        withReadStream: true,

     );
    //print(result);
  }
  return result;
  // if(result != null) {
  //   result.files[0].
  // }
  if(result != null) {
    print(result?.count);
    for (var element in result!.files) {
        print(element.name);
        //element.readStream
    }}
  

}