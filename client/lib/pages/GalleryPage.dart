import 'dart:convert';
import 'dart:math';

import 'package:client/api/v1/MediaAPI.dart';
import 'package:client/controllers/AppState.dart';
import 'package:client/controllers/GalleryState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../widgets/AppScaffold.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    Key ? key,
  }): super(key: key);

  @override
  State < GalleryPage > createState() => _GalleryPageState();
}

class _GalleryPageState extends State < GalleryPage > {
  final GalleryState galleryState = Get.find();
  int page = 0;
  int totalPages = 1;
  late ScrollController controller;
  List < dynamic> items = [];
  bool loaded = false;


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
        if( totalPages == page) { //we hit the end
          print("Loaded all media");
          return;
        }
        Map<String, dynamic> data = await listMedia(groupID: "622a2be6e2a57db0f12c682a", page: page+1);
        //print(data['docs'][0]['blurhash']); 
        //print(jsonDecode(data['docs']));
        setState(() {
          items.addAll(data['docs']);
          loaded = true;
        });
        page = data['page'];
        totalPages = data['totalPages'];
    } catch(e) {
      print("getMedia Gallery Page Error");
      print(e);
    }
    
  }

//
  Widget thumbnail(BuildContext context, int index) {
    return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15)),
              child: GestureDetector(
                onTap: () {
                  print("WILL OPEN IMAGE PAGE");
                },
                onLongPress: () {
                  print("WILL SELECT IMAGE");
                },
                onLongPressMoveUpdate: (details) {
                  print("WILL SELECT MORE MEDIA");
                  print(details);
                },
                child: BlurHash(hash: items[index]['blurhash']),
              ),
            );
  }


  Widget photoGrid(BuildContext context) {
    return GridView.builder(
        controller: controller,
        gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: ((MediaQuery.of(context).size.width > 600)?200* (pow(galleryState.mainGridZoom.value,1.5)*2):400 * (pow(galleryState.mainGridZoom.value,1.5)*0.9)),
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
      child: (loaded)?photoGrid(context):const Center(child: CircularProgressIndicator())

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