import 'package:haversine_distance/haversine_distance.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';

class RecommendExpenseCategoryQuery {
  static const int halfTimeframeInMilliseconds = 900000; // 15 minutes.
  static const int halfDistanceInMeters = 50;

  final ExpenseRepository _expenseRepository;
  final HaversineDistance _haversineDistance;

  RecommendExpenseCategoryQuery(this._expenseRepository, this._haversineDistance);

  Future<int?> execute(DateTime dateTime, double? latitude, double? longitude) async {
    final expenses = await _expenseRepository.getAll();
    if (expenses.isEmpty) {
      return null;
    }

    final distance = _haversineDistance.haversine(Location(latitude!, longitude!), Location(expenses[0].latitude!, expenses[0].longitude!), Unit.METER);
    // Map<double, Expense> distances = {};
    // if (latitude != null && longitude != null) {
    //   for (var expense in expenses) {
    //     if (expense.latitude == null || expense.longitude == null) {
    //       continue;
    //     }
    //
    //     final distance = _haversineDistance.haversine(Location(latitude, longitude), Location(expense.latitude!, expense.longitude!), Unit.METER);
    //     distances[distance] = expense;
    //   }
    // }
    //
    // Map<int, Expense> timeDifferences = {};
    // for (var expense in expenses) {
    //   final timeFrame = dateTime.millisecondsSinceEpoch;
    // }
  }
}