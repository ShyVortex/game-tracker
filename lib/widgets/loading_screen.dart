import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/waiting_widget.dart';


class LoadingScreen extends StatelessWidget {
  final Future? httpOperation;
  final Widget widget;

  const LoadingScreen({super.key,this.httpOperation,required this.widget});

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: httpOperation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget;
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else   {
            return const WaitingWidget();
          }
        }
      );
  }

}