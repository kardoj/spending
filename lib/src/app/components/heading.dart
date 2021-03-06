import 'package:flutter/cupertino.dart';

class Heading extends StatelessWidget {
  final String _text;

  const Heading(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          child: Text(_text, textScaleFactor: 2.5),
          padding: const EdgeInsets.only(top: 20))
    );
  }
}