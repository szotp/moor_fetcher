// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Item extends DataClass implements Insertable<Item> {
  final int id;
  final DateTime date;
  final String info;
  Item({@required this.id, @required this.date, @required this.info});
  factory Item.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return Item(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      info: stringType.mapFromDatabaseResponse(data['${effectivePrefix}info']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      info: serializer.fromJson<String>(json['info']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'info': serializer.toJson<String>(info),
    };
  }

  Item copyWith({int id, DateTime date, String info}) => Item(
        id: id ?? this.id,
        date: date ?? this.date,
        info: info ?? this.info,
      );
  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('info: $info')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(date.hashCode, info.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.date == this.date &&
          other.info == this.info);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> info;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.info = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    @required DateTime date,
    @required String info,
  })  : date = Value(date),
        info = Value(info);
  static Insertable<Item> custom({
    Expression<int> id,
    Expression<DateTime> date,
    Expression<String> info,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (info != null) 'info': info,
    });
  }

  ItemsCompanion copyWith(
      {Value<int> id, Value<DateTime> date, Value<String> info}) {
    return ItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      info: info ?? this.info,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('info: $info')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  final GeneratedDatabase _db;
  final String _alias;
  $ItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _infoMeta = const VerificationMeta('info');
  GeneratedTextColumn _info;
  @override
  GeneratedTextColumn get info => _info ??= _constructInfo();
  GeneratedTextColumn _constructInfo() {
    return GeneratedTextColumn(
      'info',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, date, info];
  @override
  $ItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'items';
  @override
  final String actualTableName = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info'], _infoMeta));
    } else if (isInserting) {
      context.missing(_infoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Item.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ItemsTable _items;
  $ItemsTable get items => _items ??= $ItemsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [items];
}
