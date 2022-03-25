import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html; // todo remove this and figure out a way to split code for versions
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

class _PlatformImageState extends State < PlatformImage > { // with AutomaticKeepAliveClientMixin { // 
  // @override
  // bool get wantKeepAlive => false;  //TODO: This may induse memory issues later with lots of images.  Need a better way to lazy load images

  String? webURL;
  bool disposed = false;
  @override
  void dispose() {
    disposed = true;
    print("Dispose sdsfdfsdfdsdfsfdsfsd");
     if(kIsWeb && webURL != null) {
       html.Url.revokeObjectUrl(webURL!);
       webURL=null;
      }
    super.dispose();
  }

    Future<String?> loadImageOnWeb(String url) async {
      if(!kIsWeb || webURL != null) {
        return null;
      }
      final res = await http.get(Uri.parse(url), headers: widget.headers);
      final blob = html.Blob([res.bodyBytes]);
      if(!disposed) {
        setState(() {
          webURL = html.Url.createObjectUrlFromBlob(blob);
        });
      }

      return webURL;

    }

  Widget errorWidgetDefault(String message) {
    return Container(
      decoration: const BoxDecoration(
                color: Colors.red,
      ),
      child: Center(child: SelectableText(message)),
    );
  }

  Widget cachedImage() {
    return CachedNetworkImage(
        httpHeaders: widget.headers,
        imageUrl: webURL ?? widget.url ?? "http://0.0.0.0",
        placeholder: widget.placeholder,
        errorWidget: widget.errorWidget,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        imageBuilder: (context, imageProvider) {
          return Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider,
               fit: widget.fit,
           )));
        }
    );
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

    if(kIsWeb) {
      loadImageOnWeb(widget.url!);
      if(webURL != null ) {
        return cachedImage();
      } else {
        if(widget.placeholder != null) {
          return widget.placeholder!(context, widget.url??"http://0.0.0.0");
        } else {
          return Container();
        }
      }
    } else {
      return cachedImage();
    }
    
  }
  
}