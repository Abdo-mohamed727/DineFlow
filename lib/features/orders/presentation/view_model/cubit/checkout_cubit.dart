import 'dart:developer';

import 'package:dineflow/core/enums/order_type.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/data/models/order_request.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/dining_session.dart';
import 'package:dineflow/features/orders/domain/usecase/create_dine_in_order_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/get_available_tables_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/create_take_away_order_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/start_dining_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'checkout_state.dart';
part 'checkout_cubit.freezed.dart';

@LazySingleton()
class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateTakeAwayOrderUsecase _createTakeAwayOrderUseCase;
  final CreateDineInOrderUsecase _createDineInOrderUseCase;
  final GetAvailableTablesUseCase _getAvailableTablesUseCase;
  final StartDiningUseCase _startDiningUseCase;

  CheckoutCubit(
    this._createTakeAwayOrderUseCase,
    this._createDineInOrderUseCase,
    this._getAvailableTablesUseCase,
    this._startDiningUseCase,
  ) : super(const CheckoutState.initial());

  Future<void> selectOrderType(OrderType type) async {
    final current = _selection;
    if (current == null || state is _Loading) return;

    emit(
      CheckoutState.initial(
        selection: current.copyWith(
          orderType: type,
          clearSelectedTableId: type == OrderType.takeaway,
          clearSessionId: type == OrderType.takeaway,
          clearTableName: type == OrderType.takeaway,
        ),
      ),
    );

    if (type == OrderType.dineIn && current.tables.isEmpty) {
      await loadTables();
    }
  }

  Future<void> loadTables() async {
    final current = _selection;
    if (current == null || state is _Loading) return;

    emit(
      CheckoutState.initial(selection: current.copyWith(isLoadingTables: true)),
    );
    final result = await _getAvailableTablesUseCase(const NoParams());
    final latest = _selection;
    if (latest == null || state is _Loading) return;

    switch (result) {
      case Success(data: final tables):
        emit(
          CheckoutState.initial(
            selection: latest.copyWith(
              tables: tables,
              isLoadingTables: false,
              selectedTableId: tables.any((t) => t.id == latest.selectedTableId)
                  ? latest.selectedTableId
                  : null,
              clearSelectedTableId: !tables.any(
                (t) => t.id == latest.selectedTableId,
              ),
            ),
          ),
        );
      case FailureResult(failure: final failure):
        emit(
          CheckoutState.error(
            selection: latest.copyWith(isLoadingTables: false),
            message: failure.message,
          ),
        );
    }
  }

  void selectTable(String tableId) {
    final current = _selection;
    if (current == null || state is _Loading) return;
    emit(
      CheckoutState.initial(
        selection: current.copyWith(selectedTableId: tableId),
      ),
    );
  }

  Future<void> placeOrder() async {
    final current = _selection;

    if (current == null || state is! _CheckoutInitial) return;
    if (current.isPlacingOrder) return;

    final orderType = current.orderType;
    if (orderType == null) {
      emit(
        CheckoutState.error(
          selection: current,
          message: 'Please choose an order type.',
        ),
      );
      return;
    }

    final sessionId = current.sessionId;

    if (orderType == OrderType.dineIn &&
        (sessionId == null || sessionId.isEmpty)) {
      emit(
        CheckoutState.error(
          selection: current,
          message: 'Please start a dining session before placing your order.',
        ),
      );
      return;
    }

    emit(
      CheckoutState.initial(selection: current.copyWith(isPlacingOrder: true)),
    );
    final request = orderType == OrderType.dineIn
        ? CreateOrderRequest.dineIn(diningSessionId: sessionId!)
        : CreateOrderRequest.takeaway();

    final result = orderType == OrderType.dineIn
        ? await _createDineInOrderUseCase(request)
        : await _createTakeAwayOrderUseCase(request);

    switch (result) {
      case Success(data: final order):
        emit(CheckoutState.success(order));
      case FailureResult(failure: final failure):
        final latest = _selection;
        if (latest != null) {
          emit(
            CheckoutState.error(
              selection: latest.copyWith(isPlacingOrder: false),
              message: _friendlyOrderError(failure),
            ),
          );
        }
    }
  }

  Future<void> confirmSelection() async {
    final current = _selection;
    if (current == null || state is _Loading) return;

    final orderType = current.orderType;
    if (orderType == null) {
      emit(
        CheckoutState.error(
          selection: current,
          message: 'Please choose an order type.',
        ),
      );
      return;
    }

    if (orderType == OrderType.takeaway) {
      emit(
        const CheckoutState.navigateToOrder(
          sessionId: null,
          orderType: OrderType.takeaway,
        ),
      );
      return;
    }

    final tableId = current.selectedTableId;
    if (tableId == null || tableId.isEmpty) {
      emit(
        CheckoutState.error(
          selection: current,
          message: 'Please select an available table.',
        ),
      );
      return;
    }

    final tableName = current.tables
        .cast<RestaurantTableEntity?>()
        .firstWhere((t) => t?.id == tableId, orElse: () => null)
        ?.displayName;

    if (current.sessionId != null && current.sessionId!.isNotEmpty) {
      emit(
        CheckoutState.navigateToOrder(
          sessionId: current.sessionId,
          orderType: OrderType.dineIn,
          tableId: tableId,
          tableName: tableName,
        ),
      );
      return;
    }

    emit(CheckoutState.loading(current));
    final result = await _startDiningUseCase(tableId);

    switch (result) {
      case Success(data: final sessionId):
        final latest = _selection;
        if (latest == null) return;
        final updatedSelection = latest.copyWith(
          sessionId: sessionId,
          tableName: tableName,
        );
        emit(CheckoutState.initial(selection: updatedSelection));

        emit(
          CheckoutState.navigateToOrder(
            sessionId: sessionId,
            orderType: OrderType.dineIn,
            tableId: tableId,
            tableName: tableName,
          ),
        );
      case FailureResult(failure: final failure):
        emit(CheckoutState.error(selection: current, message: failure.message));
    }
  }

  void resetAfterNavigation() {
    final current = _selection;
    emit(
      CheckoutState.initial(selection: current ?? const CheckoutSelection()),
    );
  }

  Future<void> restoreOrderSelection(OrderNavigationArguments arguments) async {
    emit(
      CheckoutState.initial(
        selection: CheckoutSelection(
          orderType: arguments.orderType,
          selectedTableId: arguments.tableId,
          sessionId: arguments.sessionId,
          tableName: arguments.tableName,
        ),
      ),
    );
    if (arguments.orderType == OrderType.dineIn &&
        (arguments.sessionId == null || arguments.sessionId!.isEmpty)) {
      await loadTables();
    }
  }

  CheckoutSelection? get _selection {
    return switch (state) {
      _CheckoutInitial(selection: final selection) => selection,
      _Loading(selection: final selection) => selection,
      _Error(selection: final selection) => selection,
      _ => null,
    };
  }

  String _friendlyOrderError(Failure failure) {
    if (failure is AuthFailure) {
      return 'Please log in again to place your order.';
    }
    if (failure is NetworkFailure) {
      return failure.message;
    }
    return failure.message;
  }
}

extension CheckoutStateX on CheckoutState {
  CheckoutSelection? get selection {
    return switch (this) {
      _CheckoutInitial(selection: final selection) => selection,
      _Loading(selection: final selection) => selection,
      _Error(selection: final selection) => selection,
      _ => null,
    };
  }

  bool get isConfirmingSelection => this is _Loading;

  String? get errorMessage {
    return switch (this) {
      _Error(message: final message) => message,
      _ => null,
    };
  }
}
