import 'dart:math';

import 'package:client/api/v1/AuthAPI.dart';
import 'package:client/api/v1/MediaAPI.dart';
import 'package:client/controllers/AppState.dart';
import 'package:client/controllers/GalleryState.dart';
import 'package:client/widgets/PlatformImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../widgets/AppScaffold.dart';
import 'package:go_router/go_router.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    Key ? key,
    required this.groupID
  }): super(key: key);

  final String groupID;

  @override
  State < GalleryPage > createState() => _GalleryPageState();
}

class _GalleryPageState extends State < GalleryPage > with AutomaticKeepAliveClientMixin {
  final GalleryState galleryState = Get.find();
  int page = 0;
  int totalPages = 1;
  bool loadLock = false;
  late ScrollController controller;
  List < dynamic > items = [];
  bool loaded = false;
  String ? accessToken;

  List < ObjectKey > thumbnailKeys = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    //getMedia();
    getMedia();
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void fillAllSpaceLoad() {
    //print(controller.position.extentAfter);
    while(controller.position.extentAfter == 0 && totalPages != page) {
      getMedia();
    }
  }

  void getMedia() async {
    try {

      loadLock = true;
      if (totalPages == page) { //we hit the end
        print("Loaded all media");
        return;
      }

      Map < String, dynamic > data = await listMedia(limit: 20, groupID: widget.groupID, page: page + 1, filter: {
        'blurhash': {
          '\$exists': true
        }
      }, sort: {
        'sortDate': -1
      });
      thumbnailKeys.addAll(List < ObjectKey > .generate(data['docs'].length, (index) => ObjectKey(data['docs'][index])));
      
      accessToken = await refreshAndGetAccessToken();
      //print(data['docs'][0]['blurhash']); 
      //print(jsonDecode(data['docs']));
      setState(() {
        items.addAll(data['docs']);
        loaded = true;
      });
      page = data['page'];
      totalPages = data['totalPages'];
      loadLock = false;
    } catch (e) {
      print("getMedia Gallery Page Error");
      print(e);
    }

  }

  Widget errorLoading(BuildContext context, int index, {Error? error}) {
    print("error from error widget");
    print(error);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [

        BlurHash(hash: items[index]['blurhash']),
        const Icon(Icons.error),
      ],
    );
  }



  //BlurHash(hash: items[index]['blurhash']),

  //
  var settings = Hive.box('settings');
  Widget thumbnail(BuildContext context, int index) {
    //String ? versionID = items[index]['files'] ? ['display'] ? [0] ? ['versionID'];
    bool valid = true;
    bool cancelClick = false;
    //print(versionID);

    if (accessToken == null) {
      valid = false;
    }

    // if(thumbnailKeys[index] == null) {
    //   thumbnailKeys[index] = GlobalKey();
    // }

    String url = settings.get('server', defaultValue: "") + "/apiv1/group/" + items[index]["groupID"] + "/media/thumbnail/" + items[index]["_id"];
    String fullQualityUrl = settings.get('server', defaultValue: "") + "/apiv1/group/" + items[index]["groupID"] + "/media/display/" + items[index]["_id"]+"/"+items[index]["files"]["display"][0]["versionID"];
    Widget blurhashPreview = BlurHash(key: ValueKey("blurhash:"+items[index]['blurhash']), hash: items[index]['blurhash']);
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
                  "Authorization": "Bearer " + accessToken!
                },
                url: fullQualityUrl,
                placeholder: (context, url) => blurhashPreview,
                errorWidget: (context, url, error) => errorLoading(context, index, error: error),
              ) : errorLoading(context, index);
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
        key: thumbnailKeys[index],
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
            context.go("/group/" + widget.groupID + "/media/" + items[index]["_id"], extra: items[index]);
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
        child: ClipRRect(

          borderRadius: BorderRadius.circular(galleryState.mainGridZoom.value * 8.0),
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
                  "Authorization": "Bearer " + accessToken!
                },
                url: url,
                //placeholder: (context, url) => blurhashPreview,
                errorWidget: (context, url, error) => errorLoading(context, index),
              ) : errorLoading(context, index),
          ),
        )
      ));

  }
  /*
  (valid)?CachedNetworkImage(
                        httpHeaders: {
                          "Authorization": "Bearer " + accessToken!
                        },
                        imageUrl: url,
                        placeholder: (context, url) => BlurHash(hash: items[index]['blurhash']),
                        errorWidget: (context, url, error) => errorLoading(context, index),
                    ):errorLoading(context, index)
                    */

  Widget photoGrid(BuildContext context) {
    if(totalPages != page && !loadLock){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        if(controller.position.extentAfter == 0) {
          getMedia();
        }
        
      });
    }
    return Scrollbar(
      controller: controller,
      child: GridView.builder(
      cacheExtent: MediaQuery.of(context).size.height*8,
      controller: controller,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: ((MediaQuery.of(context).size.width > 800) ? 500 * (pow(_remapZoom(galleryState.mainGridZoom.value, 0.1,1,0.23,1), 2) * 0.7) : 500 * (pow(_remapZoom(galleryState.mainGridZoom.value, 0.1,1,0.5,1), 4) * 1)),
        childAspectRatio: 1,
        crossAxisSpacing: 0, //galleryState.mainGridZoom.value *5,
        mainAxisSpacing: 0, ),//galleryState.mainGridZoom.value *5),
      itemCount: items.length,
      itemBuilder: thumbnail
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    //double zoomValue = galleryState.mainGridZoom.value;



    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //double gridSize = 
    return AppScaffold(
      toolbar: [
        CupertinoSlider(
          activeColor: Colors.grey[200],
          value: galleryState.mainGridZoom.value,
          min: 0.1,
          max: 1.0,
          onChanged: (newZoom) {
            //print(pow(newZoom, 2));
            setState(() {
              galleryState.mainGridZoom.value = newZoom;
            });
          })
      ],
      child: (loaded) ? photoGrid(context) : const Center(child: CircularProgressIndicator.adaptive())

      // child: ListView.builder(
      //   controller: controller,
      //   itemBuilder: (context, index) {
      //     return Container(
      //                 height: 100,
      //                 alignment: Alignment(0, 0),
      //                 color: Colors.purple,
      //                 child: Text(items[index]),
      //               );
      //   },
      //   itemCount: items.length,
      // )


    );

    // return AppScaffold(
    //     child: Scrollbar(
    //         child: SingleChildScrollView(
    //             controller: controller,
    //             child: ResponsiveGridRow(
    //                 children: items.map((i) {
    //               return ResponsiveGridCol(
    //                 lg: 2,
    //                 md: 4,
    //                 sm: 6,
    //                 xs: 12,
    //                 child: Container(
    //                   height: 100,
    //                   //alignment: Alignment(0, 0),
    //                   color: Colors.purple,
    //                   child: Text(i.toString()),
    //                 ),
    //               );
    //             }).toList()
    //                 // ListView.builder(
    //                 //   controller: controller,
    //                 //   itemBuilder: (context, index) {
    //                 //     return Text(items[index]);
    //                 //   },
    //                 //   itemCount: items.length,
    //                 // ),
    //                 ))));
    // return GridView.count(
    //   // Create a grid with 2 columns. If you change the scrollDirection to
    //   // horizontal, this produces 2 rows.
    //   //crossAxisCount: 2,
    //   // Generate 100 widgets that display their index in the List.
    //   children: List.generate(100, (index) {
    //     return Center(
    //       child: Text(
    //         'Item $index',
    //         style: Theme.of(context).textTheme.headline5,
    //       ),
    //     );
    //   }),
    // );
  }
    double _remapZoom (double value, double from1, double to1, double from2, double to2) {
      return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
  }
  void _scrollListener() {
    if (!loadLock && controller.hasClients) { // (!hasNextPage || totalPages >= page)

    //print(controller.position.extentInside);
      if (controller.position.extentAfter < 1000) {
        print("will fetch more");

        //items.addAll(List.generate(42, (index) => 'Inserted $index'));
        getMedia();

      }
    }
  }
}