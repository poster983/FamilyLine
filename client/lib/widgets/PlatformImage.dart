import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
//import 'package:universal_html/html.dart' as html; // todo remove this and figure out a way to split code for versions
//import 'package:universal_html/html.dart' as html;
class PlatformImage extends StatefulWidget {
  const PlatformImage({Key? key, this.url, this.placeholder, this.errorWidget, this.headers, this.fit=BoxFit.contain, this.width, this.height}) : super(key: key);


  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  //String? 
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Map<String, String>? headers;

  @override
  State < PlatformImage > createState() => _PlatformImageState();
}

class _PlatformImageState extends State < PlatformImage >  { //with AutomaticKeepAliveClientMixin { // 
  // @override
  // bool get wantKeepAlive => true;  //TODO: This may induse memory issues later with lots of images.  Need a better way to lazy load images
  //GlobalKey imgKey = GlobalKey();
  String? webURL;
  bool disposed = false;
  late Future<Widget> futureImage;
  @override
  void dispose() {
    disposed = true;
    print("Dispose sdsfdfsdfdsdfsfdsfsd");
    //freeWebMemory();
    super.dispose();
  }

  // void freeWebMemory() {
  //   if(kIsWeb && webURL != null) {
  //      html.Url.revokeObjectUrl(webURL!);
  //      webURL=null;
  //     }
  // }

  @override
  void initState() {
    futureImage = loadImage();
    //print("Init state");
    if(widget.url != null) {
      loadImageOnWeb(widget.url!);
    }
    
    super.initState();
  }
  
  Future<Widget> loadImage() async {
     if(widget.url == null) {
      if(widget.errorWidget != null) {
        return widget.errorWidget!(context, "", "No URL");
      } else {
          return errorWidgetDefault("No URL");
      }
    }

    if(kIsWeb) {
      await loadImageOnWeb(widget.url!);
    }
    
    return cachedImage();
  }


    Future<String?> loadImageOnWeb(String url) async {
      if(!kIsWeb || webURL != null) {
        return null;
      }
      // try{
      //   var response = await dio.get(url, options: Options( followRedirects: false, headers: widget.headers, responseType: ResponseType.bytes));
      //   print(response.statusMessage);
      //   var bytes = html.Blob(response.data);
      //   webURL = html.Url.createObjectUrlFromBlob(bytes);
      //   return webURL;
      // } on Exception catch(e) {
      //   print("Error loading image:" );
      //   return null;
      // } catch(e) {
        
      //   print("Error loading image on web:" +  e.toString());
      //   return null;
      // }
      //var response = await dio.get(url, options: Options(followRedirects: true, responseType: ResponseType.bytes));
      final res = await http.get(Uri.parse(url+"?noRedirect=true"), headers: widget.headers);
     
      if(res.statusCode != 200) {
        print("Error loading image on web:" +  res.statusCode.toString());
        return null;
      }
      //res.
      //print(response.data)
      //print(res.isRedirect);
      //final blob = html.Blob([res.bodyBytes]);
      // if(!disposed) {
      //   setState(() {
      //     //webURL = html.Url.createObjectUrlFromBlob(blob);
      //     webURL = res.body;
      //   });
      // }
      webURL = res.body;

      return webURL;

      // http.Request req = http.Request("Get", Uri.parse(url+"?noRedirect=true") )..followRedirects = false;
      // req.headers.addAll(widget.headers ?? {});
      // http.Client baseClient = http.Client();
      // http.StreamedResponse response = await baseClient.send(req);
      // if(response.statusCode != 200) {
      //  print("Error loading image on web: " +  response.statusCode.toString());
      //  return null;
      // }
      // // Uri? redirectUri;
      // // try {
      // //    redirectUri = Uri.parse(response.headers['location'] ?? "");
      // // } catch(e) {
      // //   print("Error parsing redirect url:" +  e.toString());
      // //   return null;
      // // }
      //  if(!disposed) {
      //    setState(() {
      //      webURL = response.;
      //    });
      //  }
      // return webURL;

    }

  Widget errorWidgetDefault(String message) {
    return Container(
      decoration: const BoxDecoration(
                color: Colors.red,
      ),
      child: Center(child: SelectableText(message)),
    );
  }
  bool shouldRebuild = true;
  //Widget? casheBuild;
  Widget cachedImage() {
    late Widget returner;
    
    if(shouldRebuild) {
      print("Unnessesary rebuild");
      
    }
    shouldRebuild = false;
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    //     freeWebMemory();        
    //   });
    print(webURL ?? widget.url);
    try{ 
    returner = CachedNetworkImage(
          //key:imgKey,
          httpHeaders: widget.headers,
          imageUrl: webURL ?? widget.url ?? "http://0.0.0.0",
          placeholder: widget.placeholder,
          errorWidget: widget.errorWidget,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          imageBuilder: (context, imageProvider) {
            //freeWebMemory();
            return Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider,
                fit: widget.fit,
            )));
          }
      );
    } catch(e) {
      // if(widget.errorWidget != null) {
      //   returner = widget.errorWidget!(context, webURL ?? widget.url ?? "http://0.0.0.0", e);
      // }
      rethrow;
    }
    return returner;
  }
  @override
  Widget build(BuildContext context) {
    //print(widget.url);
    if(widget.url == null) {
      if(widget.errorWidget != null) {
        return widget.errorWidget!(context, "", "No URL");
      } else {
          return errorWidgetDefault("No URL");
      }
    }

    return FutureBuilder<Widget>(
        future: futureImage, 
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            if(widget.errorWidget != null) {
              return widget.errorWidget!(context, "", "No URL");
            } else {
                return errorWidgetDefault("No URL");
            }
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });


    // if(kIsWeb) {
      
    //   if(webURL != null ) {
        
    //     return cachedImage(context);
    //   } else {
    //     if(widget.placeholder != null) {
    //       return widget.placeholder!(context, widget.url??"http://0.0.0.0");
    //     } else {
    //       return Container();
    //     }
    //   }
    // } else {
    //   return cachedImage(context);;
    // }
    
  }
  
}