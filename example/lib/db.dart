import 'package:moor/moor.dart';

part 'db.g.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get info => text()();
}

@UseMoor(tables: [Items])
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await batch((b) {
          for (int i = 0; i < 1000; i++) {
            b.insert(
              items,
              ItemsCompanion.insert(
                info: 'Item $i',
                date: DateTime.fromMillisecondsSinceEpoch(i * 1000 * 60),
              ),
            );
          }
        });
      },
    );
  }
}
