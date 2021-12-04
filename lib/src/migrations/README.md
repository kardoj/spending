### Migrations

1. Create a migration with new version. Put the version as the first number in the migration file name.
2. Look at `DatabaseProvider` and add new migration with it's version into migrations collection.
3. Update version to new version in `DatabaseProvider`'s `openDatabase` call.
NB! Don't skip any version numbers.