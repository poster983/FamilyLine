import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:go_router/go_router.dart';

class MacOSTestPage extends StatefulWidget {
  MacOSTestPage({
    Key ? key
  }): super(key: key);

  @override
  State < MacOSTestPage > createState() => _MacOSTestPageState();
}

class _MacOSTestPageState extends State < MacOSTestPage > {
  int pageIndex = 0;
  List<Widget> pages = [
    Text("Hi"),
    Text("There"),
    Text("Sir")
  ];

  // List<Widget> buildPages(BuildContext context) {
  //   bool isSingleView = MediaQuery.of(context).size.width < 500;
  //   if(isSingleView) {

  //   }
  // }

  @override
  Widget build(BuildContext context) {

    

    return DefaultTextStyle( style: MacosTypography.black.body,
      child: MacosTheme(data: MacosThemeData.dark().copyWith( primaryColor: MacosColors.appleRed, iconTheme: MacosThemeData.dark().iconTheme.copyWith(color: MacosColors.textColor)),
      child: MacosWindow(
        backgroundColor: const Color(0x00121212),
          child: MacosScaffold(
            titleBar: TitleBar(  leading: MacosBackButton(onPressed: ()=> context.pop(),),title: Text("Hello World!"),),
            children: [ContentArea(builder: ((context, scrollController) {
            return Text("Hello World!");
          }))]),
          //child: Text("this is a test")
          sidebar: Sidebar(
            topOffset: MediaQuery.of(context).padding.top,
            minWidth: 200,
            bottom: const Padding(
              padding: EdgeInsets.all(16.0),
              child: MacosListTile(
                leading: MacosIcon(CupertinoIcons.profile_circled),
                title: Text('Tim Apple'),
                subtitle: Text('tim@apple.com'),
              ),
            ), builder: (BuildContext context, ScrollController scrollController) {
              print("Sidebar Rebuild");
              // return CustomScrollView(
              //   controller: scrollController,
                
              //   slivers: < Widget > [
              //     const SliverAppBar(
              //         backgroundColor: Colors.transparent,
              //         pinned: true,
              //         // snap: _snap,
              //         // floating: _floating,
              //         expandedHeight: 80.0,
              //         flexibleSpace: FlexibleSpaceBar(
              //           title: Text('SliverAppBar'),
              //           //background: FlutterLogo(),
              //         ),
              //       ),
              //       //SliverToBoxAdapter()
              //       SliverList()
              //       SliverToBoxAdapter(

              //         child: SizedBox.expand(child: SidebarItems(
              //           currentIndex: pageIndex,
              //           onChanged: (i) => setState(() => pageIndex = i),
              //           //scrollController: scrollController,
              //           items: const [

              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.square_on_circle),
              //               label: Text('Buttons'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.arrow_2_circlepath),
              //               label: Text('Indicators'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.square_on_circle),
              //               label: Text('Buttons'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.arrow_2_circlepath),
              //               label: Text('Indicators'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.square_on_circle),
              //               label: Text('Buttons'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.exclamationmark_triangle_fill),
              //               label: Text('Error'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.scribble),
              //               label: Text('Draw'),
              //             ),
              //             SidebarItem(
              //               leading: MacosIcon(CupertinoIcons.settings),
              //               label: Text('Settings'),
              //             ),
              //           ]
              //         )
              //       )
              //       )
              //   ]
              // );
              return Column(
                children: [
                  Container(alignment: Alignment.centerLeft, child: Text("FamilyLine", style: MacosTypography.white.title1, textAlign: TextAlign.left)),
                  //SliverAppBar()
                  Expanded(child: SidebarItems(
                    currentIndex: pageIndex,
                    onChanged: (i) => setState(() => pageIndex = i),
                    scrollController: scrollController,
                    items: [

                      const SidebarItem(
                          leading: MacosIcon(CupertinoIcons.square_on_circle),
                          label: Text('Buttons'),
                        ),
                        const SidebarItem(
                          leading: MacosIcon(CupertinoIcons.arrow_2_circlepath),
                          label: Text('Indicators'),
                        ),
                    ]
                  ))
                ],

              );


            },
          )))
    );
  }
}