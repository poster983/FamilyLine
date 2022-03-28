import 'package:client/api/v1/AuthAPI.dart';
import 'package:client/api/v1/types/DBMedia.dart';
import 'package:client/controllers/GalleryState.dart';
import 'package:client/pages/ErrorPage.dart';
import 'package:client/pages/GalleryPage.dart';
import 'package:client/pages/LoginPage.dart';
import 'package:client/pages/MacOSTestPage.dart';
import 'package:client/pages/MediaPage.dart';
import 'package:client/widgets/AppScaffold.dart';
import 'package:client/widgets/CupertinoFullscreenModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'Isar.dart';
import 'controllers/AppState.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //setup encryption keys for hive
  const secureStorage = FlutterSecureStorage();
  String? key = await secureStorage.read(key: 'HiveKey'); 
  //print('Encryption key: $key');
  //create encryption key of it does not exist
  if (key == null) {
    key = base64UrlEncode(Hive.generateSecureKey());
    await secureStorage.write(
      key: 'HiveKey',
      value: key,
    );
  }
  final encryptionKey = base64Url.decode(key);
  //print('Encryption key: $encryptionKey');
  //setup hive database
  await Hive.initFlutter();
  await Hive.openBox('settings');
  final authBox= await Hive.openBox('auth', encryptionCipher: HiveAesCipher(encryptionKey));

  await setupIsar();


  //authBox.put("test", "peepee");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final controller = Get.put(AppState());
  final galcontroller = Get.put(GalleryState());
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      GoRoute(
        path: "/group/:groupID",
        //redirect: (_) =>  "/",
        builder: (c, s) {
          print("Can check for auth");
          return GalleryPage(groupID: s.params['groupID'] ?? "");
        },
        routes: [
          GoRoute(
            path: "media/:mediaID",
            builder: (context, state) {
              //Map<String, dynamic> = state.extra[;
              return MediaPage(groupID: state.params['groupID'] ?? "", mediaID: state.params['mediaID'] ?? "", mediaDoc: (state.extra != null)?state.extra as DBMedia:null,);
            }
          )
        ]
      ),
      // GoRoute(
      //   path: '/gallery',
      //   builder: (context, state) => 
      // ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: "/macos",
        builder: (context, state) => MacOSTestPage(),
      )
    ],
    initialLocation: '/',
    errorBuilder: (context, state) => ErrorPage(error: state.error,),
    // redirect: (state) {
    //   // if the user is not logged in, they need to login
    //   final loggedIn = loginInfo.loggedIn;
    //   final loggingIn = state.subloc == '/login';
    //   if (!loggedIn) return loggingIn ? null : '/login';

    //   // if the user is logged in but still on the login page, send them to
    //   // the home page
    //   if (loggingIn) return '/';

    //   // no need to redirect at all
    //   return null;
    // },

  );
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Family Line',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/gallery': (context) => const GalleryPage(),
      // },

      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  


  @override
  Widget build(BuildContext context) {
    // if(getRefreshToken() == null) { // not logged in
    //   context.go("/login");
    //   return Container();
    // }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return AppScaffold(
      toolbar: [
        IconButton(onPressed: () {
          //CupertinoFullscreenModal.of(context)?.showModal(const Text("Hello"));
          
          CupertinoFullscreenModalState().showModal(const Text("Hello"));
        }, icon: const Icon(Icons.window))
      ],
      child: ElevatedButton(
      child: Text("Login Page"),
      onPressed: () {
        context.go("/login");
      },
    ));
    // return Scaffold(
    //   appBar: AppBar(
    //       // Here we take the value from the MyHomePage object that was created by
    //       // the App.build method, and use it to set our appbar title.
    //       title: Text(widget.title),
    //       actions: <Widget>[
    //         IconButton(
    //           icon: const Icon(Icons.home),
    //           tooltip: 'Home',
    //           onPressed: () {
    //             // handle the press
    //             Get.toNamed("/");
    //           },
    //         ),
    //         IconButton(
    //           icon: const Icon(Icons.photo_size_select_actual_outlined),
    //           tooltip: 'Gallery',
    //           onPressed: () {
    //             // handle the press
    //             Get.toNamed("/gallery");
    //           },
    //         ),
    //       ]),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
