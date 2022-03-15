import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {

  const ErrorPage({Key? key, required this.error}) : super(key: key);

  final Exception? error;
  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
        body: Center(
            child: Column(children: [
              const Text("There was an error!"),
              SelectableText(error.toString())
            ],
        ))
    );
      
  }
}