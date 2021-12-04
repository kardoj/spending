import 'package:flutter_test/flutter_test.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending/src/domain/expense/expense.dart';
import 'package:spending/src/domain/expense/expense_repository.dart';
import 'package:spending/src/domain/expense/queries/recommend_expense_category_query.dart';

import '../test_expense.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}
class MockHaversineDistance extends Mock implements HaversineDistance {}
class LocationFake extends Fake implements Location {}

void main() {
  setUpAll(() {
    registerFallbackValue(LocationFake());
  });

  test('execute returns null if there are no expenses', () async {
    final repositoryMock = MockExpenseRepository();
    final haversineDistanceMock = MockHaversineDistance();
    final sut = RecommendExpenseCategoryQuery(repositoryMock, haversineDistanceMock);

    final List<Expense> expectedExpenses = [];
    when(() => repositoryMock.getAll())
      .thenAnswer((_) => Future.value(expectedExpenses));

    // Act
    var result = await sut.execute(DateTime.now(), null, null);

    // Assert
    expect(result, null);
  });

  test('execute returns null if no expense is nearby nor in timeframe', () async {
    final repositoryMock = MockExpenseRepository();
    final haversineDistanceMock = MockHaversineDistance();

    final createdAt = DateTime.now();
    const double latitude = 27;
    const double longitude = 40;

    final sut = RecommendExpenseCategoryQuery(repositoryMock, haversineDistanceMock);

    final justBeforeTimeframe = createdAt.add(const Duration(milliseconds: -(RecommendExpenseCategoryQuery.halfTimeframeInMilliseconds + 1)));
    final justAfterTimeframe = createdAt.add(const Duration(minutes: RecommendExpenseCategoryQuery.halfTimeframeInMilliseconds + 1));
    const double justOutOfDistance = RecommendExpenseCategoryQuery.halfDistanceInMeters + 1;

    final justBeforeExpense = TestExpense.create(1, justBeforeTimeframe, 8, 9);
    final justAfterExpense = TestExpense.create(2, justAfterTimeframe, 10, 11);
    final outOfRangeExpense1 = TestExpense.create(3, DateTime.now(), 12, 13);
    final outOfRangeExpense2 = TestExpense.create(4, DateTime.now(), 14, 15);
    final List<Expense> expectedExpenses = [
      justBeforeExpense,
      justAfterExpense,
      outOfRangeExpense1,
      outOfRangeExpense2
    ];

    when(() => repositoryMock.getAll())
      .thenAnswer((_) => Future.value(expectedExpenses));

    when(() => haversineDistanceMock.haversine(any(that: isEquivalentTo(Location(latitude, longitude))), any(), Unit.METER))
      .thenReturn(justOutOfDistance);
    // when(haversineDistanceMock.haversine(argThat(equals((Location location) => location.latitude == latitude && location.longitude == longitude)), argThat(equals((Location location) => location.latitude == 10 && location.longitude == 11)), Unit.METER))
    //    .thenReturn(justOutOfDistance + 300);
    // when(haversineDistanceMock.haversine(argThat(equals((Location location) => location.latitude == latitude && location.longitude == longitude)), argThat(equals((Location location) => location.latitude == 12 && location.longitude == 13)), Unit.METER))
    //    .thenReturn(justOutOfDistance + 2);
    // when(haversineDistanceMock.haversine(argThat(equals((Location location) => location.latitude == latitude && location.longitude == longitude)), argThat(equals((Location location) => location.latitude == 14 && location.longitude == 15)), Unit.METER))
    //    .thenReturn(justOutOfDistance + 1);

    // Act
    var result = await sut.execute(createdAt, latitude, longitude);

    // Assert
    expect(result, null);
  });
}