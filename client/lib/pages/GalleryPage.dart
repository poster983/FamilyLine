import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/api/v1/AuthAPI.dart';
import 'package:client/api/v1/MediaAPI.dart';
import 'package:client/controllers/AppState.dart';
import 'package:client/controllers/GalleryState.dart';
import 'package:client/widgets/PlatformImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:responsive_grid/responsive_grid.dart';
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
  late ScrollController controller;
  List < dynamic > items = [];
  bool loaded = false;
  String ? accessToken;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
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
      if (totalPages == page) { //we hit the end
        print("Loaded all media");
        return;
      }
      Map < String, dynamic > data = await listMedia(groupID: widget.groupID, page: page + 1, filter: {
        'blurhash': {
          '\$exists': true
        }
      });
      accessToken = await refreshAndGetAccessToken();
      //print(data['docs'][0]['blurhash']); 
      //print(jsonDecode(data['docs']));
      setState(() {
        items.addAll(data['docs']);
        loaded = true;
      });
      page = data['page'];
      totalPages = data['totalPages'];
    } catch (e) {
      print("getMedia Gallery Page Error");
      print(e);
    }

  }

  Widget errorLoading(BuildContext context, int index) {
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
    //print(versionID);

    if (accessToken == null) {
      valid = false;
    }

    String url = settings.get('server', defaultValue: "") + "/apiv1/group/" + items[index]["groupID"] + "/media/thumbnail/" + items[index]["_id"];
    //print(url);
    return GestureDetector(
      onTap: () {
        //print("WILL OPEN IMAGE PAGE");
        context.go("/group/"+widget.groupID+"/media/"+items[index]["_id"], extra: items[index]);
      },
      onLongPress: () {
        print("WILL SELECT IMAGE");
      },
      onLongPressMoveUpdate: (details) {
        print("WILL SELECT MORE MEDIA");
        print(details);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: (valid) ? PlatformImage(
              width: double.infinity,
              fit: BoxFit.cover,
              headers: {
                "Authorization": "Bearer " + accessToken!
              },
              url: url,
              placeholder: (context, url) => BlurHash(hash: items[index]['blurhash']),
              errorWidget: (context, url, error) => errorLoading(context, index),
            ) : errorLoading(context, index),
        ),
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
    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: ((MediaQuery.of(context).size.width > 600) ? 200 * (pow(galleryState.mainGridZoom.value, 1.5) * 2) : 400 * (pow(galleryState.mainGridZoom.value, 1.5) * 0.9)),
        childAspectRatio: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5),
      itemCount: items.length,
      itemBuilder: thumbnail

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
            print(pow(newZoom, 2));
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

  void _scrollListener() {
    if (totalPages > page && controller.hasClients) {
      // print(controller.position.extentAfter);
      if (controller.position.extentAfter < 500) {
        print("will fetch more");

        //items.addAll(List.generate(42, (index) => 'Inserted $index'));
        getMedia();

      }
    }
  }
}