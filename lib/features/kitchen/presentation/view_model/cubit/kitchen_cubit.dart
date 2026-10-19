import 'package:bloc/bloc.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/services/real_time/real_time_service.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/confirm_order_usecase.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/mark_done_order_usecase.dart';
import 'package:dineflow/features/kitchen/domain/use_cases/start_preparing_order_usecase.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:dineflow/features/orders/data/models/order_model.dart';
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
  final RealTimeService _realTimeService;

  List<OrderEntity> _orders = [];
  final Set<String> _processingOrders = {};

  KitchenCubit(
    this._getKitchenOrdersUseCase,
    this._confirmOrderUseCase,
    this._startPreparingUseCase,
    this._markReadyUseCase,
    this._realTimeService,
  ) : super(const KitchenState.initial());

  bool isProcessing(String orderId) => _processingOrders.contains(orderId);

  Future<void> start() async {
    _listenToRealTime();
    await fetchOrders();
  }

  void _listenToRealTime() {
    _realTimeService.onOrderCreated(_handleOrderCreated);
    _realTimeService.onOrderUpdate(_handleOrderUpdate);
  }

  void _handleOrderCreated(Map<String, dynamic> data) {
    if (isClosed) return;
    final newOrder = OrderModel.fromJson(data).toEntity();
    if (!_orders.any((o) => o.id == newOrder.id)) {
      _orders = [newOrder, ..._orders];
      emit(KitchenState.loaded(List.unmodifiable(_orders)));
    }
  }

  void _handleOrderUpdate(Map<String, dynamic> data) {
    if (isClosed) return;
    final orderId = data['orderId']?.toString();
    final newStatusStr = data['newStatus']?.toString();
    if (orderId == null || newStatusStr == null) return;

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final parsedStatus = OrderModel(status: newStatusStr).parsedStatus;
      final existing = _orders[index];
      _updateOrder(existing.copyWith(status: parsedStatus));
    }
  }

  Future<void> fetchOrders({bool silent = false}) async {
    if (!silent) emit(const KitchenState.loading());

    final result = await _getKitchenOrdersUseCase(NoParams());
    if (isClosed) return;

    switch (result) {
      case Success(data: final orders):
        _orders = orders;
        emit(KitchenState.loaded(List.unmodifiable(_orders)));

      case FailureResult(failure: final failure):
        // On silent refresh keep the current list instead of showing an error.
        if (!silent) emit(KitchenState.error(failure));
    }
  }

  void _updateOrder(OrderEntity updatedOrder) {
    _orders = _orders.map((order) {
      return order.id == updatedOrder.id ? updatedOrder : order;
    }).toList();

    emit(KitchenState.loaded(List.unmodifiable(_orders)));
  }

  Future<void> confirmOrder(String orderId) =>
      _runAction(orderId, _confirmOrderUseCase);

  Future<void> startPreparing(String orderId) =>
      _runAction(orderId, _startPreparingUseCase);

  Future<void> markReady(String orderId) =>
      _runAction(orderId, _markReadyUseCase);

  /// Shared logic for the three kitchen actions.
  Future<void> _runAction(
    String orderId,
    Future<Result<OrderEntity>> Function(String) useCase,
  ) async {
    if (_processingOrders.contains(orderId)) return;

    _processingOrders.add(orderId);
    emit(KitchenState.loaded(List.unmodifiable(_orders)));

    final result = await useCase(orderId);
    if (isClosed) return;

    _processingOrders.remove(orderId);

    switch (result) {
      case Success(data: final updatedOrder):
        _updateOrder(updatedOrder);

      case FailureResult(failure: final failure):
        emit(KitchenState.error(failure));
    }
  }

  @override
  Future<void> close() {
    _realTimeService.offOrderCreated(_handleOrderCreated);
    _realTimeService.offOrderUpdate(_handleOrderUpdate);
    return super.close();
  }
}
