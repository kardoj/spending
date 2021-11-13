import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/formatters/money_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:spending/src/app/pages/expenses/create_expense_page.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense_category/expense_category_repository.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ExpenseList(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (BuildContext context) => const CreateExpensePage())),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late final ExpenseCategoryRepository _expenseCategoryRepository;
  late final ExpenseRepository _expenseRepository;

  List<_ExpenseListItem> _items = [];

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> _initState() async {
    await _initServices();
    await _initItems();
  }

  Future<void> _initServices() async {
    _expenseCategoryRepository = await ExpenseCategoryRepository.getInstance();
    _expenseRepository = await ExpenseRepository.getInstance();
  }

  Future<void> _initItems() async {
    var expenses = await _expenseRepository.getAll();

    setState(() {
      _items = expenses
          .map((x) => _ExpenseListItem(x.amount, x.expenseCategory.name, x.occurredOn))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Heading("Expenses"),
        Flexible(
          child: ListView.separated(
            padding: const EdgeInsets.all(5),
            itemBuilder: (BuildContext context, int index) => _items[index],
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: _items.length
          )
        )
      ],
    );
  }
}

class _ExpenseListItem extends StatelessWidget {
  final Decimal _amount;
  final String _expenseCategoryName;
  final DateTime _occurredOn;

  const _ExpenseListItem(this._amount, this._expenseCategoryName, this._occurredOn);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(MoneyFormatter.format(_amount), textScaleFactor: 1.2),
      subtitle: Text(_expenseCategoryName),
      trailing: Text(DateFormatter.format(_occurredOn))
    );
  }
}