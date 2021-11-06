import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/forms/money_input_formatter.dart';

class CreateExpensePage extends StatelessWidget {
  const CreateExpensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: const ExpenseForm()
      )
    );
  }
}

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<int>> _expenseCategories = [
    const DropdownMenuItem(value: 1, child: Text("Üks")),
    const DropdownMenuItem(value: 2, child: Text("Kaks")),
    const DropdownMenuItem(value: 3, child: Text("Kolm"))
  ];

  int _selectedExpenseCategoryId = 1;
  String _amount = '';

  DateTime? _occurredOn = DateTime.now();
  final TextEditingController _occurredOnController = TextEditingController(
      text: DateFormatter.formatDate(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    const formElementPadding = EdgeInsets.symmetric(vertical: 5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: formElementPadding,
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Expense category'),
                items: _expenseCategories,
                value: _selectedExpenseCategoryId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedExpenseCategoryId = newValue!;
                  });
                },
              )
            ),
            Padding(
              padding: formElementPadding,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [MoneyInputFormatter()],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) => value == null || value.isEmpty ? 'Amount is required' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _amount = newValue!;
                  });
                }
              )
            ),
            Padding(
              padding: formElementPadding,
              child: TextFormField(
                controller: _occurredOnController,
                decoration: const InputDecoration(labelText: "Occurred on"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) => value == null || value.isEmpty ? 'Occurred on is required' : null,
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now.add(const Duration(days: -90)),
                    lastDate: now.add(const Duration(days: 90))
                  );

                  setState(() {
                    _occurredOn = pickedDate;
                    _occurredOnController.text = DateFormatter.formatDate(pickedDate);
                  });
                },
              ),
            ),
            Padding(
              padding: formElementPadding,
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                ),
              )
            )
          ]
        )
      )
    );
  }
}
