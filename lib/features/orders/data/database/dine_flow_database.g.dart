// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dine_flow_database.dart';

// ignore_for_file: type=lint
class $PendingOrdersTable extends PendingOrders
    with TableInfo<$PendingOrdersTable, PendingOrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientOrderIdMeta = const VerificationMeta(
    'clientOrderId',
  );
  @override
  late final GeneratedColumn<String> clientOrderId = GeneratedColumn<String>(
    'client_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverOrderIdMeta = const VerificationMeta(
    'serverOrderId',
  );
  @override
  late final GeneratedColumn<String> serverOrderId = GeneratedColumn<String>(
    'server_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sequence,
    clientOrderId,
    payload,
    status,
    retryCount,
    createdAt,
    lastError,
    serverOrderId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    }
    if (data.containsKey('client_order_id')) {
      context.handle(
        _clientOrderIdMeta,
        clientOrderId.isAcceptableOrUnknown(
          data['client_order_id']!,
          _clientOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientOrderIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('server_order_id')) {
      context.handle(
        _serverOrderIdMeta,
        serverOrderId.isAcceptableOrUnknown(
          data['server_order_id']!,
          _serverOrderIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sequence};
  @override
  PendingOrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOrderRow(
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      clientOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_order_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      serverOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_order_id'],
      ),
    );
  }

  @override
  $PendingOrdersTable createAlias(String alias) {
    return $PendingOrdersTable(attachedDatabase, alias);
  }
}

class PendingOrderRow extends DataClass implements Insertable<PendingOrderRow> {
  final int sequence;
  final String clientOrderId;
  final String payload;
  final String status;
  final int retryCount;
  final DateTime createdAt;
  final String? lastError;
  final String? serverOrderId;
  const PendingOrderRow({
    required this.sequence,
    required this.clientOrderId,
    required this.payload,
    required this.status,
    required this.retryCount,
    required this.createdAt,
    this.lastError,
    this.serverOrderId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sequence'] = Variable<int>(sequence);
    map['client_order_id'] = Variable<String>(clientOrderId);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || serverOrderId != null) {
      map['server_order_id'] = Variable<String>(serverOrderId);
    }
    return map;
  }

  PendingOrdersCompanion toCompanion(bool nullToAbsent) {
    return PendingOrdersCompanion(
      sequence: Value(sequence),
      clientOrderId: Value(clientOrderId),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      serverOrderId: serverOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverOrderId),
    );
  }

  factory PendingOrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOrderRow(
      sequence: serializer.fromJson<int>(json['sequence']),
      clientOrderId: serializer.fromJson<String>(json['clientOrderId']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      serverOrderId: serializer.fromJson<String?>(json['serverOrderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sequence': serializer.toJson<int>(sequence),
      'clientOrderId': serializer.toJson<String>(clientOrderId),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastError': serializer.toJson<String?>(lastError),
      'serverOrderId': serializer.toJson<String?>(serverOrderId),
    };
  }

  PendingOrderRow copyWith({
    int? sequence,
    String? clientOrderId,
    String? payload,
    String? status,
    int? retryCount,
    DateTime? createdAt,
    Value<String?> lastError = const Value.absent(),
    Value<String?> serverOrderId = const Value.absent(),
  }) => PendingOrderRow(
    sequence: sequence ?? this.sequence,
    clientOrderId: clientOrderId ?? this.clientOrderId,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    serverOrderId: serverOrderId.present
        ? serverOrderId.value
        : this.serverOrderId,
  );
  PendingOrderRow copyWithCompanion(PendingOrdersCompanion data) {
    return PendingOrderRow(
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      clientOrderId: data.clientOrderId.present
          ? data.clientOrderId.value
          : this.clientOrderId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      serverOrderId: data.serverOrderId.present
          ? data.serverOrderId.value
          : this.serverOrderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrderRow(')
          ..write('sequence: $sequence, ')
          ..write('clientOrderId: $clientOrderId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverOrderId: $serverOrderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sequence,
    clientOrderId,
    payload,
    status,
    retryCount,
    createdAt,
    lastError,
    serverOrderId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOrderRow &&
          other.sequence == this.sequence &&
          other.clientOrderId == this.clientOrderId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.lastError == this.lastError &&
          other.serverOrderId == this.serverOrderId);
}

class PendingOrdersCompanion extends UpdateCompanion<PendingOrderRow> {
  final Value<int> sequence;
  final Value<String> clientOrderId;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<String?> lastError;
  final Value<String?> serverOrderId;
  const PendingOrdersCompanion({
    this.sequence = const Value.absent(),
    this.clientOrderId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.serverOrderId = const Value.absent(),
  });
  PendingOrdersCompanion.insert({
    this.sequence = const Value.absent(),
    required String clientOrderId,
    required String payload,
    required String status,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    this.lastError = const Value.absent(),
    this.serverOrderId = const Value.absent(),
  }) : clientOrderId = Value(clientOrderId),
       payload = Value(payload),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<PendingOrderRow> custom({
    Expression<int>? sequence,
    Expression<String>? clientOrderId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<String>? lastError,
    Expression<String>? serverOrderId,
  }) {
    return RawValuesInsertable({
      if (sequence != null) 'sequence': sequence,
      if (clientOrderId != null) 'client_order_id': clientOrderId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastError != null) 'last_error': lastError,
      if (serverOrderId != null) 'server_order_id': serverOrderId,
    });
  }

  PendingOrdersCompanion copyWith({
    Value<int>? sequence,
    Value<String>? clientOrderId,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<String?>? lastError,
    Value<String?>? serverOrderId,
  }) {
    return PendingOrdersCompanion(
      sequence: sequence ?? this.sequence,
      clientOrderId: clientOrderId ?? this.clientOrderId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastError: lastError ?? this.lastError,
      serverOrderId: serverOrderId ?? this.serverOrderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (clientOrderId.present) {
      map['client_order_id'] = Variable<String>(clientOrderId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (serverOrderId.present) {
      map['server_order_id'] = Variable<String>(serverOrderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrdersCompanion(')
          ..write('sequence: $sequence, ')
          ..write('clientOrderId: $clientOrderId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverOrderId: $serverOrderId')
          ..write(')'))
        .toString();
  }
}

abstract class _$DineFlowDatabase extends GeneratedDatabase {
  _$DineFlowDatabase(QueryExecutor e) : super(e);
  $DineFlowDatabaseManager get managers => $DineFlowDatabaseManager(this);
  late final $PendingOrdersTable pendingOrders = $PendingOrdersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pendingOrders];
}

typedef $$PendingOrdersTableCreateCompanionBuilder =
    PendingOrdersCompanion Function({
      Value<int> sequence,
      required String clientOrderId,
      required String payload,
      required String status,
      Value<int> retryCount,
      required DateTime createdAt,
      Value<String?> lastError,
      Value<String?> serverOrderId,
    });
typedef $$PendingOrdersTableUpdateCompanionBuilder =
    PendingOrdersCompanion Function({
      Value<int> sequence,
      Value<String> clientOrderId,
      Value<String> payload,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<String?> lastError,
      Value<String?> serverOrderId,
    });

class $$PendingOrdersTableFilterComposer
    extends Composer<_$DineFlowDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientOrderId => $composableBuilder(
    column: $table.clientOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverOrderId => $composableBuilder(
    column: $table.serverOrderId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOrdersTableOrderingComposer
    extends Composer<_$DineFlowDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientOrderId => $composableBuilder(
    column: $table.clientOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverOrderId => $composableBuilder(
    column: $table.serverOrderId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOrdersTableAnnotationComposer
    extends Composer<_$DineFlowDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get clientOrderId => $composableBuilder(
    column: $table.clientOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get serverOrderId => $composableBuilder(
    column: $table.serverOrderId,
    builder: (column) => column,
  );
}

class $$PendingOrdersTableTableManager
    extends
        RootTableManager<
          _$DineFlowDatabase,
          $PendingOrdersTable,
          PendingOrderRow,
          $$PendingOrdersTableFilterComposer,
          $$PendingOrdersTableOrderingComposer,
          $$PendingOrdersTableAnnotationComposer,
          $$PendingOrdersTableCreateCompanionBuilder,
          $$PendingOrdersTableUpdateCompanionBuilder,
          (
            PendingOrderRow,
            BaseReferences<
              _$DineFlowDatabase,
              $PendingOrdersTable,
              PendingOrderRow
            >,
          ),
          PendingOrderRow,
          PrefetchHooks Function()
        > {
  $$PendingOrdersTableTableManager(
    _$DineFlowDatabase db,
    $PendingOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sequence = const Value.absent(),
                Value<String> clientOrderId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverOrderId = const Value.absent(),
              }) => PendingOrdersCompanion(
                sequence: sequence,
                clientOrderId: clientOrderId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                lastError: lastError,
                serverOrderId: serverOrderId,
              ),
          createCompanionCallback:
              ({
                Value<int> sequence = const Value.absent(),
                required String clientOrderId,
                required String payload,
                required String status,
                Value<int> retryCount = const Value.absent(),
                required DateTime createdAt,
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverOrderId = const Value.absent(),
              }) => PendingOrdersCompanion.insert(
                sequence: sequence,
                clientOrderId: clientOrderId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                createdAt: createdAt,
                lastError: lastError,
                serverOrderId: serverOrderId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$DineFlowDatabase,
      $PendingOrdersTable,
      PendingOrderRow,
      $$PendingOrdersTableFilterComposer,
      $$PendingOrdersTableOrderingComposer,
      $$PendingOrdersTableAnnotationComposer,
      $$PendingOrdersTableCreateCompanionBuilder,
      $$PendingOrdersTableUpdateCompanionBuilder,
      (
        PendingOrderRow,
        BaseReferences<
          _$DineFlowDatabase,
          $PendingOrdersTable,
          PendingOrderRow
        >,
      ),
      PendingOrderRow,
      PrefetchHooks Function()
    >;

class $DineFlowDatabaseManager {
  final _$DineFlowDatabase _db;
  $DineFlowDatabaseManager(this._db);
  $$PendingOrdersTableTableManager get pendingOrders =>
      $$PendingOrdersTableTableManager(_db, _db.pendingOrders);
}
