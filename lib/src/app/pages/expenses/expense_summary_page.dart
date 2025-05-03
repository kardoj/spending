import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:spending/src/app/components/formatters/money_formatter.dart';
import 'package:spending/src/app/components/heading.dart';
import 'package:spending/src/app/pages/expenses/create_expense_page.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense/queries/current_month_expense_summary_query.dart';

class ExpenseSummaryPage extends StatelessWidget {
  const ExpenseSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ExpenseSummary(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (BuildContext context) => const CreateExpensePage())),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ExpenseSummary extends StatefulWidget {
  const ExpenseSummary({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  late final ExpenseRepository _expenseRepository;

  List<_ExpenseSummaryItem> _items = [];
  Decimal _total = Decimal.zero;

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
    var summaryItems = await CurrentMonthExpenseSummaryQuery(_expenseRepository)
        .execute();

    _total = summaryItems.fold(Decimal.zero, (total, element) => total + element.amount);

    summaryItems.sort((a, b) => b.amount.compareTo(a.amount));

    setState(() {
      _items = summaryItems
          .map((x) => _ExpenseSummaryItem(x.amount, x.expenseCategory.name))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Heading("Summary"),
        Text("Total: " + MoneyFormatter.format(_total), textScaler: const TextScaler.linear(2)),
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

class _ExpenseSummaryItem extends StatelessWidget {
  final Decimal _amount;
  final String _expenseCategoryName;

  const _ExpenseSummaryItem(this._amount, this._expenseCategoryName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_expenseCategoryName, textScaleFactor: 1.2),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(MoneyFormatter.format(_amount))
        ],
      )
    );
  }
}