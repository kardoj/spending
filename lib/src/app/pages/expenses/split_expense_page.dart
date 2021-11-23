import 'package:collection/src/iterable_extensions.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/formatters/money_formatter.dart';
import 'package:spending/src/app/components/forms/money_input_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:spending/src/app/pages/expenses/expenses_page.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense_category/expense_category_repository.dart';

class SplitExpensePage extends StatelessWidget {
  final int _expenseId;

  const SplitExpensePage(this._expenseId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: SplitExpenseForm(_expenseId)
      )
    );
  }
}

class SplitExpenseForm extends StatefulWidget {
  final int _expenseId;

  const SplitExpenseForm(this._expenseId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplitExpenseFormState();
}

class _SplitExpenseFormState extends State<SplitExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ExpenseCategoryRepository _expenseCategoryRepository;
  late final ExpenseRepository _expenseRepository;
  Expense? _expense;

  List<DropdownMenuItem<int>> _expenseCategoryOptions = [];

  int? _selectedSplitExpenseCategoryId;
  String? _splitExpenseAmount;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    await _initServices();
    await _initExpenseCategoryOptions();
    await _findExpense();
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

      _selectedSplitExpenseCategoryId = expenseCategories.firstWhereOrNull((x) => x.name == 'Food')?.id;
    });
  }

  Future<void> _findExpense() async {
    var expense = (await _expenseRepository.find(widget._expenseId))!;
    setState(() {
      _expense = expense;
    });
  }

  Future<void> _splitExpenseAndNavigateToExpenses() async {
    await _expenseRepository.split(_expense!.id, _selectedSplitExpenseCategoryId!, Decimal.parse(_splitExpenseAmount!));
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
                  const Heading('Split expense'),
                  Padding(
                    padding: formElementPadding,
                    child: Text('Split part of ${MoneyFormatter.format(_expense?.amount ?? Decimal.parse('0'))} on \'${_expense?.expenseCategory.name}\' to another expense on ${DateFormatter.format(_expense?.occurredOn ?? DateTime.now())}.')
                  ),
                  Padding(
                      padding: formElementPadding,
                      child: DropdownButtonFormField<int>(
                        key: const ValueKey('split-expense-category-input'),
                        decoration: const InputDecoration(labelText: 'Expense category'),
                        items: _expenseCategoryOptions,
                        value: _selectedSplitExpenseCategoryId,
                        validator: (int? value) => value == null ? 'Expense category is required' : null,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedSplitExpenseCategoryId = newValue!;
                          });
                        },
                      )
                  ),
                  Padding(
                      padding: formElementPadding,
                      child: TextFormField(
                          key: const ValueKey("split-expense-amount-input"),
                          decoration: const InputDecoration(labelText: 'Amount'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [MoneyInputFormatter()],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Amount is required';
                            }

                            // TODO(KJ): This is not ideal.
                            if (_expense == null) {
                              return 'Wait for expense to be loaded';
                            }

                            if (Decimal.parse(value) >= _expense!.amount) {
                              return 'Amount must be less than ${_expense!.amount}';
                            }
                          },
                          onChanged: (String? newValue) {
                            setState(() {
                              _splitExpenseAmount = newValue!;
                            });
                          }
                      )
                  ),
                  Padding(
                      padding: formElementPadding,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.pop(context)
                            ),
                            ElevatedButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _splitExpenseAndNavigateToExpenses();
                                  }
                                }
                            )
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}