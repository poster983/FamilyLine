import 'package:client/api/v1/AuthAPI.dart';
import 'package:client/api/v1/MediaAPI.dart';
import 'package:client/widgets/PlatformImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hive/hive.dart';
import 'package:zoom_widget/zoom_widget.dart';

var settings = Hive.box('settings');

class MediaPage extends StatefulWidget {
  final String mediaID;
  final String groupID;
  final Map < String, dynamic > ? mediaDoc;
  const MediaPage({
    Key ? key,
    required this.groupID,
    required this.mediaID,
    this.mediaDoc
  }): super(key: key);

  @override
  State < MediaPage > createState() => _MediaPageState();
}

class _MediaPageState extends State < MediaPage > {
  Map < String,
  dynamic > ? mediaDoc;

  String? errorMessage;
  String? accessToken;

  var imageKey = UniqueKey();
  @override
  void initState() {
    mediaDoc = widget.mediaDoc;
     // only get from server if not passed
      getDoc();
  
    super.initState();
  }


  void getDoc() async {
    try{
      accessToken = await refreshAndGetAccessToken();
      setState(() {
        
      });
    } catch(e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
      return;
    }
    if (mediaDoc == null) {
      getMediaByID(groupID: widget.groupID, mediaID: widget.mediaID).then((value) {
        setState(() {
          mediaDoc = value;
        });
      }).catchError((e) {
        print(e);
        setState(() {
          errorMessage = e.toString();
        });
      });
    }
    
  }


  ///Display an error on the page
  Widget errorWidget(BuildContext context, String? message) {
    String? blurhash = mediaDoc?['blurhash'];
    if(blurhash!=null) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [

          BlurHash(hash: blurhash),
          Column(children: [
            const Icon(Icons.error),
            (message !=null)?SelectableText(message):Container(),
          ],)
          
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
            const Icon(Icons.error),
            (message !=null)?SelectableText(message):Container(),
          ]);
    
  }


  Widget image(BuildContext context) {
    String? versionID = mediaDoc?['files']?['display']?[0]?['versionID'];
    if(versionID == null) {
      return errorWidget(context, "The file may not be processed yet or does not exist. Please try again later");
    }
    String url = settings.get("server", defaultValue: "") + "/apiv1/group/"+widget.groupID+"/media/display/"+mediaDoc!["_id"]+"/"+versionID;
    String? blurhash = mediaDoc?['blurhash'];
    return Zoom(
      maxZoomWidth: 1920,
      maxZoomHeight: 1080,
      enableScroll: true,
      doubleTapZoom: true,
      child: PlatformImage(
        key: imageKey,
      headers: {
        "Authorization": "Bearer " + accessToken!
      },
      url: url,
      placeholder: (context, url) => (blurhash != null )?BlurHash(hash: blurhash):const CircularProgressIndicator.adaptive(),
      errorWidget: (context, url, error) => errorWidget(context, error),
    ));
  }


  @override
  Widget build(BuildContext context) {
    late Widget mediaWidget;
    print(errorMessage);
    if(errorMessage != null) {
      mediaWidget= errorWidget(context, errorMessage);
    } else if (mediaDoc == null || accessToken == null) { //waiting for mediadoc to load 
      mediaWidget = const Center(child: CircularProgressIndicator.adaptive());
    } else {
      if(mediaDoc!['type'] == "IMAGE") {
        mediaWidget = image(context);
      } else {
        throw UnimplementedError("Only implemented images");
      }
    }
    
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
        ),
        child: mediaWidget,
      )
    );

  }
}