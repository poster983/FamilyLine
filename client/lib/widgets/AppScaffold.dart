import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:client/AppState.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
// TODO: BAD VERY BAD GET RID OF THIS
int selected = 0;

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
              Get.toNamed("/gallery");
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
        nav: "/gallery"),
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
          appBar: AdaptiveAppBar(title: const Text('Default Demo'), actions: toolbar),
          body: child,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              print(appState.pageIndex.value);
            },
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
