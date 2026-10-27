import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_dine_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_takeaway_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_order_by_id_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/order_id_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_state.dart';
part 'order_cubit.freezed.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  final CreateDineOrderUseCase _createDineOrderUseCase;
  final CreateTakeAwayOrderUseCase _createTakeawayOrderUseCase;
  final GetOrdersUseCaseWaiter _getOrdersUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  OrderCubit(
    this._createDineOrderUseCase,
    this._createTakeawayOrderUseCase,
    this._getOrdersUseCase,
    this._getOrdersByStatusUseCase,
    this._getOrderByIdUseCase,
    this._updateOrderStatusUseCase,
  ) : super(OrderState.initial());

  Future<void> createDineOrder(CreateDineOrderParams params) async {
    emit(const OrderState.loading());

    final result = await _createDineOrderUseCase(params);

    switch (result) {
      case Success(data: final data):
        emit(OrderState.orderCreated(data));
        await getOrders();
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }

  Future<void> createTakeawayOrder(CreateTakeAwayOrderParams params) async {
    emit(const OrderState.loading());

    final result = await _createTakeawayOrderUseCase(params);

    switch (result) {
      case Success(data: final data):
        emit(OrderState.orderCreated(data));
        await getOrders();
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }

  Future<void> getOrders() async {
    emit(const OrderState.loading());

    final result = await _getOrdersUseCase(const NoParams());

    switch (result) {
      case Success(data: final data):
        emit(OrderState.ordersLoaded(data));
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }

  Future<void> getOrdersByStatus(String status) async {
    emit(const OrderState.loading());

    final result = await _getOrdersByStatusUseCase(
      GetOrdersByStatusParams(status: status),
    );

    switch (result) {
      case Success(data: final data):
        emit(OrderState.ordersLoaded(data));
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }

  Future<void> getOrderById(String orderId) async {
    emit(const OrderState.loading());

    final result = await _getOrderByIdUseCase(OrderIdParams(orderId: orderId));

    switch (result) {
      case Success(data: final data):
        emit(OrderState.orderLoaded(data));
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    emit(const OrderState.loading());

    final result = await _updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: orderId, status: status),
    );

    switch (result) {
      case Success(data: final data):
        emit(OrderState.orderStatusUpdated(data));
      case FailureResult(failure: final failure):
        emit(OrderState.error(failure.message));
    }
  }
}
