import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  final List<Widget>? toolbar;
  final Widget child;

  const AppScaffold({Key? key, required this.child, this.toolbar})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    Widget body;
    Widget? drawer;
    if (MediaQuery.of(context).size.width > 600) {
      body = Row(children: [buildDrawer(), child]);
    } else {
      body = child;
      drawer = buildDrawer();
    }

    return Scaffold(
        body: body,
        appBar: AppBar(
          title: Text("Family Line"),
          actions: (toolbar != null) ? toolbar : [],
        ),
        drawer: drawer);
  }
}
