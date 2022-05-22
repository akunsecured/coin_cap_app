import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(),
        ),
      );
}
