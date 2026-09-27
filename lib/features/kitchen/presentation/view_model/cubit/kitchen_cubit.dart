import 'package:bloc/bloc.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/confirm_order_usecase.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/mark_done_order_usecase.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/start_preparing_order_usecase.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'kitchen_state.dart';
part 'kitchen_cubit.freezed.dart';

@injectable
class KitchenCubit extends Cubit<KitchenState> {
  final GetOrdersUseCase _getKitchenOrdersUseCase;
  final ConfirmOrderUseCase _confirmOrderUseCase;
  final StartPreparingUseCase _startPreparingUseCase;
  final MarkReadyUseCase _markReadyUseCase;

  List<OrderEntity> _orders = [];

  KitchenCubit(
    this._getKitchenOrdersUseCase,
    this._confirmOrderUseCase,
    this._startPreparingUseCase,
    this._markReadyUseCase,
  ) : super(const KitchenState.initial());

  Future<void> fetchOrders() async {
    emit(const KitchenState.loading());

    final result = await _getKitchenOrdersUseCase(NoParams());

    switch (result) {
      case Success(data: final orders):
        _orders = orders;
        emit(KitchenState.loaded(_orders));

      case FailureResult(failure: final failure):
        emit(KitchenState.error(failure));
    }
  }

  void _updateOrder(OrderEntity updatedOrder) {
    _orders = _orders.map((order) {
      if (order.id == updatedOrder.id) {
        return updatedOrder;
      }

      return order;
    }).toList();

    emit(KitchenState.loaded(List.unmodifiable(_orders)));
  }

  Future<void> confirmOrder(String orderId) async {
    final result = await _confirmOrderUseCase(orderId);

    switch (result) {
      case Success(data: final updatedOrder):
        _updateOrder(updatedOrder);

      case FailureResult(failure: final failure):
        emit(KitchenState.error(failure));
    }
  }

  Future<void> startPreparing(String orderId) async {
    final result = await _startPreparingUseCase(orderId);

    switch (result) {
      case Success(data: final updatedOrder):
        _updateOrder(updatedOrder);

      case FailureResult(failure: final failure):
        emit(KitchenState.error(failure));
    }
  }

  Future<void> markReady(String orderId) async {
    final result = await _markReadyUseCase(orderId);

    switch (result) {
      case Success(data: final updatedOrder):
        _updateOrder(updatedOrder);

      case FailureResult(failure: final failure):
        emit(KitchenState.error(failure));
    }
  }
}
