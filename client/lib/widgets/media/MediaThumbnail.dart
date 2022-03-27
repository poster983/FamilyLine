
import 'package:client/widgets/PlatformImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../api/v1/types/DBMedia.dart';

// class MediaThumbnail extends StatefulWidget {
//   const MediaThumbnail({ Key? key, required this.media, required this.accessToken}) : super(key: key);

//   final DBMedia media;
//   final String accessToken;
//   @override
//   State<MediaThumbnail> createState() => _MediaThumbnailState();
// }

// class _MediaThumbnailState extends State<MediaThumbnail> {
//   final settings = Hive.box('settings');
//   //TODO: fix


//   Widget errorLoading(BuildContext context, {Error? error}) {
//     print("error from error widget");
//     print(error);
//     return Stack(
//       alignment: AlignmentDirectional.center,
//       children: [

//         (widget.media.blurhash!=null)?BlurHash(hash: widget.media.blurhash!):Container(color: Colors.blueGrey,),
//         const Icon(Icons.error),
//       ],
//     );
//   }


//   Widget thumbnail(BuildContext context) {
//     //String ? versionID = items[index]['files'] ? ['display'] ? [0] ? ['versionID'];
//     bool valid = true;
//     bool cancelClick = false;
//     //print(versionID);
//     //var accessToken getAccessToken();
//     // if (accessToken == null) {
//     //   valid = false;
//     // }

//     // if(thumbnailKeys[index] == null) {
//     //   thumbnailKeys[index] = GlobalKey();
//     // }
//     //var media = widget.media;
//     //print(widget.media.mongoID);
//     String url = settings.get('server', defaultValue: "") + "/apiv1/group/" + widget.media.groupID + "/media/thumbnail/" + widget.media.mongoID;
//     String fullQualityUrl = settings.get('server', defaultValue: "") + "/apiv1/group/" + widget.media.groupID + "/media/display/" + widget.media.mongoID+"/"+widget.media.files.display?[0].versionID;
//     Widget blurhashPreview = (widget.media.blurhash!=null)?BlurHash(key: ValueKey("blurhash:"+widget.media.blurhash!), hash: widget.media.blurhash!):const CircularProgressIndicator.adaptive();
//     //var imageKey = ValueKey('penis');
//     //print(url);
//     return CupertinoContextMenu(
//       previewBuilder: (BuildContext context, Animation<double> animation, Widget child) {
          
//           //print("Load full image for preview");
//           Widget childWidget = blurhashPreview;
//           if(animation.isCompleted) {
//             HapticFeedback.heavyImpact();
//             print("animation Done");
//             childWidget = (valid) ? PlatformImage(

//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 headers: {
//                   "Authorization": "Bearer " + widget.accessToken
//                 },
//                 url: fullQualityUrl,
//                 placeholder: (context, url) => blurhashPreview,
//                 errorWidget: (context, url, error) => errorLoading(context, error: error),
//               ) : errorLoading(context);
//           }
//           return ClipRRect(
//               borderRadius: BorderRadius.circular(32.0 * animation.value),
//             //   FittedBox(
//             // fit: BoxFit.cover,
//             // // This ClipRRect rounds the corners of the image when the
//             // // CupertinoContextMenu is open, even though it's not rounded when
//             // // it's closed. It uses the given animation to animate the corners
//             // // in sync with the opening animation.
            
//             // child:
//             // width: double.infinity,
//             // alignment: Alignment.center,
//             // decoration: const BoxDecoration(
//             //     color: Colors.grey,
//             //   ),
//               child: childWidget
//           );
            
            
          
//         },
//       actions: < Widget > [
//         CupertinoContextMenuAction(
//           isDefaultAction: true,
//           child: const Text('Select'),
//             onPressed: () {
//               HapticFeedback.selectionClick();
//               //Navigator.
//               Navigator.pop(context);
//             },
//         ),
//         CupertinoContextMenuAction(
//           isDestructiveAction: true,
//           child: const Text('Delete'),
//             onPressed: () {
//               HapticFeedback.heavyImpact();
//               Navigator.pop(context);
//             },
//         ),
//       ],
//       child: GestureDetector(
//         //key: thumbnailKeys[index],
//         onTapDown: (_) async {
//           cancelClick = false;
//           print("start");
//           await Future.delayed(const Duration(milliseconds: 100));
//           print("timeout");
//           cancelClick = true;
//         },
//         onTapUp: (_) {
//           if (cancelClick == false) {
//             print("go to media");
//             context.go("/group/" + widget.media.groupID + "/media/" + widget.media.mongoID, extra: widget.media);
//           }
//         },
//         onTapCancel: () {
//           print("tap cancel ");
//           cancelClick = true;
//         },

//         // onTap: () {
//         //   //print("WILL OPEN IMAGE PAGE");

//         // },
//         onLongPress: () {
//           HapticFeedback.selectionClick();
//         },
//         // onLongPressMoveUpdate: (details) {
//         //   print("WILL SELECT MORE MEDIA");
//         //   print(details);
//         // },
//         child: Container(
//             width: double.infinity,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//                 color: Colors.grey,
//               ),
//               child: (valid) ? PlatformImage(
//                 //key: UniqueKey(),
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 headers: {
//                   "Authorization": "Bearer " + widget.accessToken
//                 },
//                 url: url,
//                 //placeholder: (context, url) => blurhashPreview,
//                 errorWidget: (context, url, error) => errorLoading(context, error: error),
//               ) : errorLoading(context),
//           ),
//         )
//       );

//   }

//   @override
//   Widget build(BuildContext context) {
//     return thumbnail(context);
//   }
// }


class MediaThumbnail extends StatelessWidget {
  MediaThumbnail({Key? key, required this.media, required this.accessToken}) : super(key: key);
  final DBMedia media;
  final String accessToken;
  final settings = Hive.box('settings');

    Widget errorLoading(BuildContext context, {Error? error}) {
    print("error from error widget");
    print(error);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [

        (media.blurhash!=null)?BlurHash(hash: media.blurhash!):Container(color: Colors.blueGrey,),
        const Icon(Icons.error),
      ],
    );
  }


  Widget thumbnail(BuildContext context) {
    //String ? versionID = items[index]['files'] ? ['display'] ? [0] ? ['versionID'];
    bool valid = true;
    bool cancelClick = false;
    //print(versionID);
    //var accessToken getAccessToken();
    // if (accessToken == null) {
    //   valid = false;
    // }

    // if(thumbnailKeys[index] == null) {
    //   thumbnailKeys[index] = GlobalKey();
    // }
    //var media = widget.media;
    //print(widget.media.mongoID);
    String url = settings.get('server', defaultValue: "") + "/apiv1/group/" + media.groupID + "/media/thumbnail/" + media.mongoID;
    String fullQualityUrl = settings.get('server', defaultValue: "") + "/apiv1/group/" + media.groupID + "/media/display/" + media.mongoID+"/"+media.files.display?[0].versionID;
    Widget blurhashPreview = (media.blurhash!=null)?BlurHash(key: ValueKey("blurhash:"+media.blurhash!), hash: media.blurhash!):const CircularProgressIndicator.adaptive();
    //var imageKey = ValueKey('penis');
    //print(url);
    return CupertinoContextMenu(
      previewBuilder: (BuildContext context, Animation<double> animation, Widget child) {
          
          //print("Load full image for preview");
          Widget childWidget = blurhashPreview;
          if(animation.isCompleted) {
            HapticFeedback.heavyImpact();
            print("animation Done");
            childWidget = (valid) ? PlatformImage(

                width: double.infinity,
                fit: BoxFit.cover,
                headers: {
                  "Authorization": "Bearer " + accessToken
                },
                url: fullQualityUrl,
                placeholder: (context, url) => blurhashPreview,
                errorWidget: (context, url, error) => errorLoading(context, error: error),
              ) : errorLoading(context);
          }
          return ClipRRect(
              borderRadius: BorderRadius.circular(32.0 * animation.value),
            //   FittedBox(
            // fit: BoxFit.cover,
            // // This ClipRRect rounds the corners of the image when the
            // // CupertinoContextMenu is open, even though it's not rounded when
            // // it's closed. It uses the given animation to animate the corners
            // // in sync with the opening animation.
            
            // child:
            // width: double.infinity,
            // alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //     color: Colors.grey,
            //   ),
              child: childWidget
          );
            
            
          
        },
      actions: < Widget > [
        CupertinoContextMenuAction(
          isDefaultAction: true,
          child: const Text('Select'),
            onPressed: () {
              HapticFeedback.selectionClick();
              //Navigator.
              Navigator.pop(context);
            },
        ),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          child: const Text('Delete'),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.pop(context);
            },
        ),
      ],
      child: GestureDetector(
        //key: thumbnailKeys[index],
        onTapDown: (_) async {
          cancelClick = false;
          print("start");
          await Future.delayed(const Duration(milliseconds: 100));
          print("timeout");
          cancelClick = true;
        },
        onTapUp: (_) {
          if (cancelClick == false) {
            print("go to media");
            context.go("/group/" + media.groupID + "/media/" + media.mongoID, extra: media);
          }
        },
        onTapCancel: () {
          print("tap cancel ");
          cancelClick = true;
        },

        // onTap: () {
        //   //print("WILL OPEN IMAGE PAGE");

        // },
        onLongPress: () {
          HapticFeedback.selectionClick();
        },
        // onLongPressMoveUpdate: (details) {
        //   print("WILL SELECT MORE MEDIA");
        //   print(details);
        // },
        child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: (valid) ? PlatformImage(
                //key: UniqueKey(),
                width: double.infinity,
                fit: BoxFit.cover,
                headers: {
                  "Authorization": "Bearer " + accessToken
                },
                url: url,
                //placeholder: (context, url) => blurhashPreview,
                errorWidget: (context, url, error) => errorLoading(context, error: error),
              ) : errorLoading(context),
          ),
        )
      );

  }

  @override
  Widget build(BuildContext context) {
    return thumbnail(context);
  }
}