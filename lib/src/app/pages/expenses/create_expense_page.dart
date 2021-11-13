import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/forms/money_input_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:collection/collection.dart';
import 'package:spending/src/app/pages/expenses/expenses_page.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense_category/expense_category_repository.dart';

class CreateExpensePage extends StatelessWidget {
  const CreateExpensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: const ExpenseForm()
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (BuildContext context) => const ExpensesPage())),
        label: const Text("View expenses")),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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

  late final ExpenseCategoryRepository _expenseCategoryRepository;
  late final ExpenseRepository _expenseRepository;

  List<DropdownMenuItem<int>> _expenseCategoryOptions = [];

  int? _selectedExpenseCategoryId;
  String? _amount;

  DateTime? _occurredOn = DateTime.now();
  final TextEditingController _occurredOnController = TextEditingController(
      text: DateFormatter.format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    await _initServices();
    await _initExpenseCategoryOptions();
  }

  Future<void> _initServices() async {
    _expenseCategoryRepository = await ExpenseCategoryRepository.getInstance();
    _expenseRepository = await ExpenseRepository.getInstance();
  }

  Future<void> _initExpenseCategoryOptions() async {
    var expenseCategories = await _expenseCategoryRepository.getAll();

    setState(() {
      _expenseCategoryOptions = expenseCategories
          .map((x) => DropdownMenuItem(value: x.id, child: Text(x.name)))
          .toList();

      _selectedExpenseCategoryId = expenseCategories.firstWhereOrNull((x) => x.name == 'Food')?.id;
    });
  }

  Future<void> _createExpenseAndNavigateToExpenses() async {
    await _expenseRepository.create(Decimal.parse(_amount!), _selectedExpenseCategoryId!, _occurredOn!);
    await Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (BuildContext context) => const ExpensesPage()));
  }

  @override
  Widget build(BuildContext context) {
    const formElementPadding = EdgeInsets.symmetric(vertical: 5, horizontal: 8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Heading("Register expense"),
            Padding(
              padding: formElementPadding,
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Expense category'),
                items: _expenseCategoryOptions,
                value: _selectedExpenseCategoryId,
                validator: (int? value) => value == null ? 'Expense category is required' : null,
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
                    _occurredOnController.text = DateFormatter.format(pickedDate);
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
                    if (_formKey.currentState!.validate()) {
                      _createExpenseAndNavigateToExpenses();
                    }
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
