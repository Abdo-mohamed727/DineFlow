part of 'waiter_cubit.dart';

@freezed
class WaiterState with _$WaiterState {
  const factory WaiterState.initial() = _Initial;

  const factory WaiterState.loading() = _Loading;

  const factory WaiterState.error(
    String message,
  ) = _Error;

  const factory WaiterState.requestsLoaded(
    WaiterRequestsPageEntity requests,
  ) = _RequestsLoaded;

  const factory WaiterState.requestUpdated(
    WaiterRequestEntity request,
  ) = _RequestUpdated;

  const factory WaiterState.ordersLoaded(
    OrdersPageEntity orders,
  ) = _OrdersLoaded;

  const factory WaiterState.orderLoaded(
    OrderWaiterEntity order,
  ) = _OrderLoaded;

  const factory WaiterState.orderCreated(
    CreateOrderEntity order,
  ) = _OrderCreated;

  const factory WaiterState.orderStatusUpdated(
    OrderWaiterEntity order,
  ) = _OrderStatusUpdated;

  const factory WaiterState.tablesLoaded(
    TablesEntity tables,
  ) = _TablesLoaded;

  const factory WaiterState.tableLoaded(
    TableEntity table,
  ) = _TableLoaded;

  const factory WaiterState.tableUpdated(
    TableEntity table,
  ) = _TableUpdated;
}