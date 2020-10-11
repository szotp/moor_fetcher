library moor_fetcher;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';

/// Fetches data from database in pages. Reloads automatically on change.
abstract class DatabaseFetcher<T> extends ChangeNotifier {
  Selectable<T> query(T last, int limit);

  @protected
  int get pageSize => 50;

  @protected
  int get loadingMargin => 10;

  List<T> _items = [];

  int get count => _allLoaded ? _items.length : _items.length + 1;

  bool _allLoaded = false;

  StreamSubscription _sub;

  bool _setupDone = false;
  Future<void> setup() async {
    final firstPage = Completer();

    _sub = query(null, pageSize).watch().listen((items) {
      handleReactiveChange(items);
      if (!firstPage.isCompleted) {
        firstPage.complete();
      }
    });

    await firstPage.future;
  }

  /// Returns unique id of this item that can be used to compare for differences
  @protected
  dynamic identify(T item);

  @protected
  bool get resetOnChange => false;

  @protected
  void handleReactiveChange(List<T> firstPage) {
    if (resetOnChange || _items.length <= firstPage.length) {
      _items = firstPage;
      _allLoaded = firstPage.length < pageSize;
      notifyListeners();
      return;
    }

    // determine what was deleted / removed
    // this only works on changes that were done to the first page
    // for other cases, it may be enough to call reset, which will completely delete old state

    final oldSet = _items.sublist(0, pageSize).map(identify).toSet();
    final newSet = firstPage.map(identify).toSet();

    final added = newSet.difference(oldSet).length;
    final removed = oldSet.difference(newSet).length - added;
    var lengthDifference = added - removed;

    while (lengthDifference > 0) {
      _items.insert(0, null);
      lengthDifference--;
    }

    while (lengthDifference < 0) {
      _items.removeAt(0);
      lengthDifference++;
    }

    _items.setRange(0, firstPage.length, firstPage);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    _allLoaded = false;
    notifyListeners();
  }

  dispose() {
    super.dispose();
    _sub?.cancel();
  }

  T getAt(int index) {
    if (index >= _items.length) {
      _fetchNext();
      return null;
    }

    if (index >= _items.length - loadingMargin) {
      _fetchNext();
    }

    return _items[index];
  }

  Future<void> _runningFetch;

  void _fetchNext() {
    if (_allLoaded) {
      return;
    }

    _runningFetch ??=
        _fetchNextInner().whenComplete(() => _runningFetch = null);
  }

  Future<void> _fetchNextInner() async {
    if (!_setupDone) {
      await setup();
      _setupDone = true;
      assert(_items.isNotEmpty);
      return;
    }

    final last = _items.isNotEmpty ? _items.last : null;

    final nextPage = await query(last, pageSize).get();
    _allLoaded = nextPage.length < pageSize;

    _items.addAll(nextPage);
    notifyListeners();
  }
}

class ExistsExpression extends Expression<bool> {
  Query select;

  ExistsExpression(this.select);

  void where(JoinedSelectStatement selectOnly, Expression<bool> predicate) {
    selectOnly.addColumns([selectOnly.table.primaryKey.first]);
    selectOnly.where(predicate);
    select = selectOnly;
  }

  @override
  void writeInto(GenerationContext context) {
    context.buffer.write('(exists (');
    final q = select.constructQuery();
    final sql = q.sql;
    context.buffer.write(sql.substring(0, sql.length - 1));

    for (int i = 0; i < q.amountOfVariables; i++) {
      context.introduceVariable(q.introducedVariables[i], q.boundVariables[i]);
    }

    context.buffer.write('))');
  }
}

class OrderByWhere<T extends Table> extends Expression<bool> {
  @override
  void writeInto(GenerationContext context) {
    void writeList(List<Component> components) {
      context.buffer.write('(');

      bool addComma = false;
      for (final e in components) {
        if (addComma) {
          context.buffer.write(',');
        }
        e.writeInto(context);
        addComma = true;
      }
      context.buffer.write(')');
    }

    writeList(whereLeft);
    context.buffer.write(mode == OrderingMode.desc ? '<' : '>');
    writeList(whereRight);
  }

  OrderingMode mode = OrderingMode.asc;

  List<Component> whereLeft = [];
  List<Component> whereRight = [];
  List<OrderingTerm> terms = [];

  void add<X>(Expression<X> column, X value) {
    terms.add(OrderingTerm(expression: column, mode: mode));

    if (value != null) {
      whereLeft.add(column);

      whereRight.add(Constant(value));
    }
  }
}

extension OrderByWhereExtension<T extends Table, D extends DataClass>
    on SimpleSelectStatement<T, D> {
  /// Sorts and filters at the same time. Useful for efficient pagination, where we want to fetch items after certain item.
  /// Example usage:
  /// ```dart
  /// query.orderByWhere((x, b) {
  ///   b.add(x.firstName, anchor?.firstName);
  ///   b.add(x.lastName, anchor?.lastName)
  /// });
  /// ```
  void orderByWhere(void Function(T, OrderByWhere<T>) func) {
    final builder = OrderByWhere<T>();
    func(table as T, builder);

    orderBy(builder.terms.map((x) => (_) => x).toList());

    if (builder.whereLeft.isNotEmpty) {
      where((x) => builder);
    }
  }
}

extension WhereExistsJoined on JoinedSelectStatement {
  void whereExists(void Function(ExistsExpression) func) {
    final x = ExistsExpression(null);
    func(x);
    where(x);
  }
}

extension WhereExistsSimple on SimpleSelectStatement {
  void whereExists(void Function(ExistsExpression) func) {
    final x = ExistsExpression(null);
    func(x);
    where((_) => x);
  }
}
