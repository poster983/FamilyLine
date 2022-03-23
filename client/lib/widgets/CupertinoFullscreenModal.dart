import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoFullscreenModalInherited extends InheritedWidget {
  final CupertinoFullscreenModalState data;

  const CupertinoFullscreenModalInherited({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class CupertinoFullscreenModal extends StatefulWidget {
  final Widget child;
  const CupertinoFullscreenModal({
    Key? key,
    required this.child,
  }) : super(key: key);

  static CupertinoFullscreenModalState? of(BuildContext context) {
    final CupertinoFullscreenModalInherited? one = context.dependOnInheritedWidgetOfExactType<CupertinoFullscreenModalInherited>();
    print(one);
    return one?.data;
  }

  @override
  CupertinoFullscreenModalState createState() => CupertinoFullscreenModalState();
}

class CupertinoFullscreenModalState extends State<CupertinoFullscreenModal> {
  bool opened = false;
  @override
  void initState() {
    super.initState();
  }

  showModal(Widget child, {Function(dynamic popValue)? onClose}) {
    setState(() {
      opened = true;
    });
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return SizedBox(
          key: const Key('CupertinoFullscreenModal'),
          height: MediaQuery.of(context).size.height * 0.9,
          child: ClipRRect(
            borderRadius: opened
                ? const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  )
                : BorderRadius.zero,
            child: child,
          ),
        );
      },
    ).then((value) {
      setState(() {
        opened = false;
      });
      if (onClose != null) {
        onClose(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoFullscreenModalInherited(
      data: this,
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: opened ? 30 : 0, vertical: opened ? 50 : 0),
          width:
              opened ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width,
          height: opened
              ? MediaQuery.of(context).size.height * 0.8
              : MediaQuery.of(context).size.height,
          child: ClipRRect(
            borderRadius: opened ? BorderRadius.circular(25) : BorderRadius.zero,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}