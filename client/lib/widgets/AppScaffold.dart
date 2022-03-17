import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:client/controllers/AppState.dart';
import 'package:client/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';



// class AppScaffold extends StatefulWidget {
//   const AppScaffold({Key? key, required this.child, this.toolbar})
//       : super(key: key);
//   final List<Widget>? toolbar;
//   final Widget child;
//   @override
//   State<AppScaffold> createState() => _AppScaffoldState();
// }

// class _AppScaffoldState extends State<AppScaffold> {
class AppScaffold extends StatelessWidget {
  final List<Widget>? toolbar;
  final Widget child;
  final AppState appState = Get.find();
  //RxInt index = 0.obs;

  AppScaffold({Key? key, required this.child, this.toolbar}) : super(key: key);

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text('Drawer Header'),
          // ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app.
              // ...
              Get.toNamed("/");
            },
          ),
          ListTile(
            title: const Text('Gallery'),
            onTap: () {
              // Update the state of the app.
              // ...
              Get.toNamed("/group/622e80202d9894fe032c4eac/gallery");
            },
          ),
          ListTile(
            title: const Text('Upload'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

  List<_NavItem> destinations = [
    _NavItem(
        widget: const AdaptiveScaffoldDestination(
          title: 'Home',
          icon: Icons.home,
        ),
        nav: "/"),
    _NavItem(
        widget: const AdaptiveScaffoldDestination(
            title: 'Gallery', icon: Icons.photo_size_select_actual_rounded),
        nav: "/group/622e80202d9894fe032c4eac"),
  ];

  @override
  Widget build(BuildContext context) {
    //   Widget body;
    //   Widget? drawer;
    //   if (MediaQuery.of(context).size.width > 600) {
    //     body = Row(children: [buildDrawer(), child]);
    //   } else {
    //     body = child;
    //     drawer = buildDrawer();
    //   }

    //   return Scaffold(
    //       body: body,
    //       appBar: AppBar(
    //         title: const Text("Family Line"),
    //         actions: (toolbar != null) ? toolbar : [],
    //       ),
    //       drawer: drawer);
    // }

    return Obx(() => AdaptiveNavigationScaffold(
          selectedIndex: appState.pageIndex.value,
          destinations: destinations.map((e) => e.widget).toList(),
          onDestinationSelected: (_index) {
            context.go(destinations[_index].nav);
            appState.pageIndex.value = _index;
          },
          appBar: AdaptiveAppBar(title: const Text('FamilyLine'), actions: toolbar),
          body: child,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.upload_rounded),
            onPressed: () async {
              print(appState.pageIndex.value);
              var files = await showUploadUI(context);
              if(files ==null) {
                return;
              }
              for (var element in files.files) {
                if(element.readStream == null) {
                  continue;
                }
                appState.uploader.queueUpload(filename: element.name, fileStream: element.readStream!);
              }},
          ),
          fabInRail: true,
          includeBaseDestinationsInMenu: true,
        ));
  }
}

class _NavItem {
  final AdaptiveScaffoldDestination widget;
  final String nav;
  _NavItem({required this.widget, required this.nav});
}


