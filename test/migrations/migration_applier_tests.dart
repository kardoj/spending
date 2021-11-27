import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spending/src/migrations/migration.dart';
import 'package:spending/src/migrations/migration_applier.dart';
import 'package:sqflite/sqflite.dart';

import 'migration_applier_tests.mocks.dart';

@GenerateMocks([Migration, Database])
void main() {
  test('goUp applies second migration when going from version 1 to 2', () async {
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock
    };

    final databaseMock = MockDatabase();

    final sut = MigrationApplier();

    // Act
    await sut.goUp(versionToMigrationMap, databaseMock, 1, 2);

    // Assert
    verifyNever(version1MigrationMock.up(databaseMock));
    verifyNever(version1MigrationMock.down(databaseMock));
    verifyNever(version2MigrationMock.down(databaseMock));

    verify(version2MigrationMock.up(databaseMock)).called(1);
  });

  test('goUp applies second and third migration when going from version 1 to 3', () async {
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();
    final version3MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock,
      3: version3MigrationMock
    };

    final databaseMock = MockDatabase();

    final sut = MigrationApplier();

    // Act
    await sut.goUp(versionToMigrationMap, databaseMock, 1, 3);

    // Assert
    verifyNever(version1MigrationMock.up(databaseMock));
    verifyNever(version1MigrationMock.down(databaseMock));
    verifyNever(version2MigrationMock.down(databaseMock));
    verifyNever(version3MigrationMock.down(databaseMock));

    verifyInOrder([
      version2MigrationMock.up(databaseMock),
      version3MigrationMock.up(databaseMock)
    ]);
  });

  test('goDown rolls back second migration when going from version 2 to 1', () async {
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock
    };

    final databaseMock = MockDatabase();

    final sut = MigrationApplier();

    // Act
    await sut.goDown(versionToMigrationMap, databaseMock, 2, 1);

    // Assert
    verifyNever(version1MigrationMock.up(databaseMock));
    verifyNever(version1MigrationMock.down(databaseMock));
    verifyNever(version2MigrationMock.up(databaseMock));

    verify(version2MigrationMock.down(databaseMock)).called(1);
  });

  test('goDown rolls back second and third migration when going from version 3 to 1', () async {
    final version1MigrationMock = MockMigration();
    final version2MigrationMock = MockMigration();
    final version3MigrationMock = MockMigration();

    final Map<int, Migration> versionToMigrationMap = {
      1: version1MigrationMock,
      2: version2MigrationMock,
      3: version3MigrationMock
    };

    final databaseMock = MockDatabase();

    final sut = MigrationApplier();

    // Act
    await sut.goDown(versionToMigrationMap, databaseMock, 3, 1);

    // Assert
    verifyNever(version1MigrationMock.up(databaseMock));
    verifyNever(version2MigrationMock.up(databaseMock));
    verifyNever(version3MigrationMock.up(databaseMock));
    verifyNever(version1MigrationMock.down(databaseMock));

    verifyInOrder([
      version3MigrationMock.down(databaseMock),
      version2MigrationMock.down(databaseMock)
    ]);
  });
}