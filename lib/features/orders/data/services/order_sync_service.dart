import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dineflow/core/error/failure.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/entity/order_entity.dart';
import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/domain/repo/order_repository_interface.dart';

class OrderSyncService {
  OrderSyncService(
    this._repository, {
    Stream<List<ConnectivityResult>>? connectivityChanges,
    Future<List<ConnectivityResult>> Function()? checkConnectivity,
    Future<void> Function(Duration)? delay,
  }) : _connectivityChanges =
           connectivityChanges ?? Connectivity().onConnectivityChanged,
       _checkConnectivity =
           checkConnectivity ?? Connectivity().checkConnectivity,
       _delay = delay ?? _defaultDelay;

  static const _maxRetries = 5;

  final OrderRepositoryInterface _repository;
  final Stream<List<ConnectivityResult>> _connectivityChanges;
  final Future<List<ConnectivityResult>> Function() _checkConnectivity;
  final Future<void> Function(Duration) _delay;

  final _syncCompleted = StreamController<void>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Future<void>? _activeSync;

  Stream<void> get syncCompleted => _syncCompleted.stream;

  Future<void> start() async {
    if (_connectivitySubscription != null) return;

    await _resetStaleSendingOrders();
    _connectivitySubscription = _connectivityChanges.listen((results) {
      if (_isOnline(results)) {
        _triggerBackgroundSync();
      }
    });

    if (_isOnline(await _checkConnectivity())) {
      _triggerBackgroundSync();
    }
  }

  Future<void> stop() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  Future<void> syncPendingOrders() {
    final activeSync = _activeSync;
    if (activeSync != null) return activeSync;

    late final Future<void> sync;
    sync = _synchronize().whenComplete(() {
      _syncCompleted.add(null);
      if (identical(_activeSync, sync)) {
        _activeSync = null;
      }
    });
    _activeSync = sync;
    return sync;
  }

  Future<void> _synchronize() async {
    await _resetStaleSendingOrders();
    final orders = await _repository.getPendingOrders();

    for (final order in orders) {
      if (order.status == PendingOrderStatus.failed) continue;
      if (order.serverOrderId != null) {
        await _repository.deletePendingOrder(order.clientOrderId);
        continue;
      }

      var retryCount = order.retryCount;
      while (true) {
        await _repository.updatePendingOrderStatus(
          order.clientOrderId,
          PendingOrderStatus.sending,
          retryCount: retryCount,
        );
        final result = await _repository.sendPendingOrder(
          order.copyWith(
            status: PendingOrderStatus.sending,
            retryCount: retryCount,
          ),
        );
        if (result is Success<OrderEntity>) {
          await _repository.deletePendingOrder(order.clientOrderId);
          break;
        }

        final failure = (result as FailureResult<OrderEntity>).failure;
        if (failure is NetworkFailure) {
          await _repository.updatePendingOrderStatus(
            order.clientOrderId,
            PendingOrderStatus.pending,
          );
          return;
        }

        if (_isRateLimited(failure) || _isServerError(failure)) {
          retryCount++;
          if (retryCount >= _maxRetries) {
            await _repository.updatePendingOrderStatus(
              order.clientOrderId,
              PendingOrderStatus.failed,
              retryCount: retryCount,
              lastError: failure.message,
            );
            break;
          }
          await _repository.updatePendingOrderStatus(
            order.clientOrderId,
            PendingOrderStatus.pending,
            retryCount: retryCount,
            lastError: failure.message,
          );
          await _delay(_retryDelay(retryCount));
          continue;
        }

        await _repository.updatePendingOrderStatus(
          order.clientOrderId,
          PendingOrderStatus.failed,
          lastError: failure.message,
        );
        break;
      }
    }
  }

  Future<void> _resetStaleSendingOrders() async {
    final orders = await _repository.getPendingOrders();
    for (final order in orders) {
      if (order.status == PendingOrderStatus.sending) {
        await _repository.updatePendingOrderStatus(
          order.clientOrderId,
          PendingOrderStatus.pending,
        );
      }
    }
  }

  void _triggerBackgroundSync() {
    unawaited(
      syncPendingOrders().catchError((Object error, StackTrace stackTrace) {
        developer.log(
          'Background order synchronization failed.',
          error: error,
          stackTrace: stackTrace,
          level: 1000,
        );
      }),
    );
  }

  Duration _retryDelay(int retryCount) {
    final seconds = math.min(60, 1 << (retryCount - 1));
    return Duration(seconds: seconds);
  }

  bool _isRateLimited(Failure failure) => failure.statusCode == 429;

  bool _isServerError(Failure failure) =>
      failure.statusCode != null &&
      failure.statusCode! >= 500 &&
      failure.statusCode! < 600;

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  static Future<void> _defaultDelay(Duration duration) {
    return Future<void>.delayed(duration);
  }
}
