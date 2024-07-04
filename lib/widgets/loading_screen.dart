import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {
  final Future? httpOperation;
  final Widget widget;

  LoadingScreen({super.key,this.httpOperation,required this.widget});

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: httpOperation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return widget;
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else   {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
  }

}