import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../AppState.dart';
import '../widgets/AppScaffold.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    Key ? key,
  }): super(key: key);

  @override
  State < GalleryPage > createState() => _GalleryPageState();
}

class _GalleryPageState extends State < GalleryPage > {
  late ScrollController controller;
  List < String > items = List.generate(1000, (index) => 'Hello $index');

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Get.find();
    double zoomValue = appState.mainGridZoom.value;

    
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
          value: appState.mainGridZoom.value, 
          min: 0.1,
          max: 1.0, 
          onChanged: (newZoom) {
            
            setState(() {
              appState.mainGridZoom.value = newZoom;
              zoomValue = newZoom;
            });
          })
      ],
      child: GridView.builder(
        controller: controller,
        gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: ((MediaQuery.of(context).size.width > 600)?200* (zoomValue*2):400 * (zoomValue*0.9)),
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
          itemCount: items.length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              child: Text(items[index]),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15)),
            );
          }

      )

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
    if (controller.hasClients) {
      print(controller.position.extentAfter);
      if (controller.position.extentAfter < 500) {
        setState(() {
          items.addAll(List.generate(42, (index) => 'Inserted $index'));
        });
      }
    }
  }
}