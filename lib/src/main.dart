import 'package:flutter/material.dart';

import 'app/pages/expenses/create/create_expense_page.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)),
      home: const CreateExpensePage()
    );
  }
}
