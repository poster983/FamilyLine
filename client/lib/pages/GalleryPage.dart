import 'dart:math';

import 'package:client/api/v1/AuthAPI.dart';
import 'package:client/api/v1/MediaAPI.dart';
import 'package:client/api/v1/types/APIPagination.dart';
import 'package:client/api/v1/types/DBMedia.dart';
import 'package:client/controllers/AppState.dart';
import 'package:client/controllers/GalleryState.dart';
import 'package:client/widgets/PlatformImage.dart';
import 'package:client/widgets/media/MediaThumbnail.dart';
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
  List < DBMedia > items = [];
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

  void getMedia() async {
    try {

      loadLock = true;
      if (totalPages == page) { //we hit the end
        print("Loaded all media");
        return;
      }

      APIPagination<DBMedia> data = await listMediaFromServer(limit: 20, groupID: widget.groupID, page: page + 1, filter: {
        'blurhash': {
          '\$exists': true
        }
      }, sort: {
        'sortDate': -1
      });
      //thumbnailKeys.addAll(List < ObjectKey > .generate(data['docs'].length, (index) => ObjectKey(data['docs'][index])));
      
      accessToken = await refreshAndGetAccessToken();
      if(accessToken == null) {
        return;
      }
      //print(data['docs'][0]['blurhash']); 
      //print(jsonDecode(data['docs']));
      setState(() {
        items.addAll(data.docs);
        loaded = true;
      });
      page = data.page;
      totalPages = data.totalPages;
      loadLock = false;
    } catch (e) {
      print("getMedia Gallery Page Error");
      print(e);
    }

  }



  Widget photoGrid(BuildContext context) {
    if(totalPages != page && !loadLock){
      WidgetsBinding.instance!.addPostFrameCallback((_){
        if(controller.position.extentAfter < MediaQuery.of(context).size.height/3) {
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
      itemBuilder: (context, index) {
        return MediaThumbnail(media: items[index], accessToken: accessToken ?? "");
      }
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