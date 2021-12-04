import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spending/src/migrations/migration.dart';
import 'package:spending/src/migrations/migration_applier.dart';
import 'package:sqflite/sqflite.dart';

class MockMigration extends Mock implements Migration {}
class MockDatabase extends Mock implements Database {}

void main() {
  test('goUp applies second migration when going from version 1 to 2', () async {
    final databaseMock = MockDatabase();
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock
    };

    when(() => version2MigrationMock.up(databaseMock))
      .thenAnswer((_) async {});

    final sut = MigrationApplier();

    // Act
    await sut.goUp(versionToMigrationMap, databaseMock, 1, 2);

    // Assert
    verify(() => version2MigrationMock.up(databaseMock)).called(1);
  });

  test('goUp applies second and third migration when going from version 1 to 3', () async {
    final databaseMock = MockDatabase();
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();
    final version3MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock,
      3: version3MigrationMock
    };

    when(() => version2MigrationMock.up(databaseMock))
      .thenAnswer((_) async {});
    when(() => version3MigrationMock.up(databaseMock))
      .thenAnswer((_) async {});

    final sut = MigrationApplier();

    // Act
    await sut.goUp(versionToMigrationMap, databaseMock, 1, 3);

    // Assert
    verifyInOrder([
       () => version2MigrationMock.up(databaseMock),
       () => version3MigrationMock.up(databaseMock)
    ]);
  });

  test('goDown rolls back second migration when going from version 2 to 1', () async {
    final databaseMock = MockDatabase();
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock
    };

    when(() => version2MigrationMock.down(databaseMock))
        .thenAnswer((_) async {});

    final sut = MigrationApplier();

    // Act
    await sut.goDown(versionToMigrationMap, databaseMock, 2, 1);

    // Assert
    verify(() => version2MigrationMock.down(databaseMock)).called(1);
  });

  test('goDown rolls back second and third migration when going from version 3 to 1', () async {
    final databaseMock = MockDatabase();
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();
    final version3MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock,
      3: version3MigrationMock
    };

    when(() => version3MigrationMock.down(databaseMock))
        .thenAnswer((_) async {});
    when(() => version2MigrationMock.down(databaseMock))
        .thenAnswer((_) async {});

    final sut = MigrationApplier();

    // Act
    await sut.goDown(versionToMigrationMap, databaseMock, 3, 1);

    // Assert
    verifyInOrder([
      () => version3MigrationMock.down(databaseMock),
      () => version2MigrationMock.down(databaseMock)
    ]);
  });
}