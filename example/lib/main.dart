import 'package:flutter/material.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:moor_fetcher/moor_fetcher.dart';

import 'db.dart';

Future<void> main() async {
  final db = Database(VmDatabase.memory());
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final Database db;

  const MyApp({Key key, this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(db: db),
    );
  }
}

class ItemsFetcher extends DatabaseFetcher<Item> {
  final Database db;

  ItemsFetcher(this.db);

  @override
  Selectable<Item> query(Item last, int limit) {
    print('Fetching after $last');
    final query = db.select(db.items);
    query.limit(limit);
    query.orderByWhere((x, b) {
      b.mode = OrderingMode.desc;
      b.add(x.date, last?.date);
    });

    return query;
  }

  @override
  identify(Item item) => item.date;

  void add() {
    db.into(db.items).insert(
        ItemsCompanion.insert(date: DateTime.now(), info: 'Added manually'));
  }

  void remove() {
    db.delete(db.items).delete(getAt(0));
  }
}

class MyHomePage extends StatefulWidget {
  final Database db;

  const MyHomePage({Key key, this.db}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ItemsFetcher _fetcher;

  @override
  void initState() {
    _fetcher = ItemsFetcher(widget.db);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _fetcher.add),
          IconButton(icon: Icon(Icons.remove), onPressed: _fetcher.remove),
        ],
      ),
      body: AnimatedBuilder(
        animation: _fetcher,
        builder: (context, _) {
          return ListView.builder(
            itemBuilder: (context, i) {
              final item = _fetcher.getAt(i);
              if (item == null) {
                return CircularProgressIndicator();
              }
              return ListTile(
                title: Text(item.info),
              );
            },
            itemCount: _fetcher.count,
          );
        },
      ),
    );
  }
}
