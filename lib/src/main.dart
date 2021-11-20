import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/pages/expenses/create_expense_page.dart';

const _colorSchemePrimaryValue = 0xFF8F1E20;
const MaterialColor _colorSchemePrimarySwatch = MaterialColor(
  _colorSchemePrimaryValue,
  <int, Color>{
    50: Color(0xFFF4E9E9),
    100: Color(0xFFE9D2D2),
    200: Color(0xFFDDBCBC),
    300: Color(0xFFD2A5A6),
    400: Color(0xFFC78F90),
    500: Color(0xFFBC7879),
    600: Color(0xFFB16263),
    700: Color(0xFFA54B4D),
    800: Color(_colorSchemePrimaryValue),
    900: Color(0xFF72181A),
  }
);

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    return MaterialApp(
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: _colorSchemePrimarySwatch)),
      home: const CreateExpensePage()
    );
  }
}
