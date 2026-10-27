part of 'checkout_cubit.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial({
    @Default(CheckoutSelection()) CheckoutSelection selection,
  }) = _CheckoutInitial;
  const factory CheckoutState.loading(CheckoutSelection selection) = _Loading;
  const factory CheckoutState.error({
    required CheckoutSelection selection,
    required String message,
  }) = _Error;
  const factory CheckoutState.navigateToOrder({
    required String? sessionId,
    required OrderType orderType,
    String? tableId,
    String? tableName,
  }) = _NavigateToOrder;
  const factory CheckoutState.success(OrderEntity order) = _CheckoutSuccess;
}

class CheckoutSelection {
  final OrderType? orderType;
  final String? selectedTableId;
  final List<RestaurantTableEntity> tables;
  final bool isLoadingTables;
  final bool isPlacingOrder;
  final String? sessionId;

  /// Human-readable name of the selected table (e.g. "Table 3").
  final String? tableName;

  const CheckoutSelection({
    this.orderType,
    this.selectedTableId,
    this.tables = const [],
    this.isLoadingTables = false,
    this.isPlacingOrder = false,
    this.sessionId,
    this.tableName,
  });

  CheckoutSelection copyWith({
    OrderType? orderType,
    String? selectedTableId,
    List<RestaurantTableEntity>? tables,
    bool? isLoadingTables,
    bool? isPlacingOrder,
    String? sessionId,
    String? tableName,
    bool clearSelectedTableId = false,
    bool clearSessionId = false,
    bool clearTableName = false,
  }) {
    return CheckoutSelection(
      orderType: orderType ?? this.orderType,
      selectedTableId: clearSelectedTableId
          ? null
          : (selectedTableId ?? this.selectedTableId),
      tables: tables ?? this.tables,
      isLoadingTables: isLoadingTables ?? this.isLoadingTables,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      sessionId: clearSessionId ? null : (sessionId ?? this.sessionId),
      tableName: clearTableName ? null : (tableName ?? this.tableName),
    );
  }
}
