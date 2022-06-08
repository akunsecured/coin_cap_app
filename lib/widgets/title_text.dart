import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;

  const TitleText(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(color: Colors.white54, fontSize: 18.0));
}
