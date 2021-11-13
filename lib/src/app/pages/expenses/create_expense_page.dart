import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/forms/money_input_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:spending/src/domain/expense/commands/create_expense_command.dart';
import 'package:spending/src/domain/expense_category/queries/all_expense_categories_query.dart';
import 'package:spending/src/infrastructure/commands/command_mediator.dart';
import 'package:spending/src/infrastructure/queries/query_mediator.dart';
import 'package:collection/collection.dart';

// TODO: Täpsustada, miks osa asju tuleb läbi "package" importida ja osa saab niimoodi?
import 'expenses_page.dart';

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

  late final QueryMediator _queryMediator;
  late final CommandMediator _commandMediator;

  List<DropdownMenuItem<int>> _expenseCategoryOptions = [];

  int? _selectedExpenseCategoryId;
  String? _amount;

  DateTime? _occurredOn = DateTime.now();
  final TextEditingController _occurredOnController = TextEditingController(
      text: DateFormatter.formatDate(DateTime.now()));

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
    _queryMediator = await QueryMediator.getInstance();
    _commandMediator = await CommandMediator.getInstance();
  }

  Future<void> _initExpenseCategoryOptions() async {
    var expenseCategories = await _queryMediator.send(AllExpenseCategoriesQuery());

    setState(() {
      _expenseCategoryOptions = expenseCategories
          .map((x) => DropdownMenuItem(value: x.id, child: Text(x.name)))
          .toList();

      _selectedExpenseCategoryId = expenseCategories.firstWhereOrNull((x) => x.name == 'Food')?.id;
    });
  }

  Future<void> _createExpenseAndNavigateToExpenses() async {
    await _commandMediator.send(CreateExpenseCommand(Decimal.parse(_amount!), _selectedExpenseCategoryId!, _occurredOn!));
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
