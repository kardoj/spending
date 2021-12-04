import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/date_formatter.dart';
import 'package:spending/src/app/components/formatters/money_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:spending/src/app/pages/expenses/create_expense_page.dart';
import 'package:spending/src/app/pages/expenses/split_expense_page.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';

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
    _expenseRepository = await ExpenseRepository.getInstance();
  }

  Future<void> _initItems() async {
    var expenses = await _expenseRepository.getCurrentMonth();

    setState(() {
      _items = expenses
          .map((x) => _ExpenseListItem(x.id, x.amount, x.expenseCategory.name, x.occurredOn, _deleteExpense))
          .toList();
    });
  }

  Future<void> _deleteExpense(int id) async {
    await _expenseRepository.delete(id);

    setState(() {
      _items.removeWhere((x) => x.id == id);
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
  final int _id;
  final Decimal _amount;
  final String _expenseCategoryName;
  final DateTime _occurredOn;
  final Future<void> Function(int id) _deleteExpense;

  get id => _id;

  const _ExpenseListItem(this._id, this._amount, this._expenseCategoryName, this._occurredOn, this._deleteExpense);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(MoneyFormatter.format(_amount), textScaleFactor: 1.2),
      subtitle: Text(_expenseCategoryName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateFormatter.format(_occurredOn)),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.splitscreen_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => SplitExpensePage(_id))),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final deleteConfirmed = await showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: const Text('Delete expense?'),
                  content: Text('${MoneyFormatter.format(_amount)} spent on "$_expenseCategoryName" on ${DateFormatter.format(_occurredOn)}'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('DELETE'))
                  ],
                );
              });

              if (deleteConfirmed) {
                await _deleteExpense(_id);
              }
            }
          )
        ],
      )
    );
  }
}