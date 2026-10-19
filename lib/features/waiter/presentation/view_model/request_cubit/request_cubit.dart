import 'package:bloc/bloc.dart';
import 'package:dineflow/core/services/real_time/real_time_service.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:dineflow/features/waiter/domain/use_case/accept_request_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/complete_request_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_pending_requests_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/request_id_params.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'request_state.dart';
part 'request_cubit.freezed.dart';

@injectable
class RequestCubit extends Cubit<RequestState> {
  final GetPendingRequestsUseCase _getPendingRequestsUseCase;
  final AcceptRequestUseCase _acceptRequestUseCase;
  final CompleteRequestUseCase _completeRequestUseCase;
  final RealTimeService _realTimeService;

  RequestCubit(
    this._getPendingRequestsUseCase,
    this._acceptRequestUseCase,
    this._completeRequestUseCase,
    this._realTimeService,
  ) : super(RequestState.initial());

  Future<void> start() async {
    _realTimeService.onWaiterRequestCreated(_onWaiterRequestCreated);
    _realTimeService.onWaiterRequestUpdated(_onWaiterRequestUpdated);
    await getPendingRequests();
  }

  void _onWaiterRequestCreated(Map<String, dynamic> request) {
    getPendingRequests(silent: true);
  }

  void _onWaiterRequestUpdated(Map<String, dynamic> payload) {
    getPendingRequests(silent: true);
  }

  Future<void> getPendingRequests({bool silent = false}) async {
    if (!silent) emit(const RequestState.loading());
    final result = await _getPendingRequestsUseCase(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Success(data: final data):
        emit(RequestState.requestsLoaded(data));
      case FailureResult(failure: final failure):
        if (!silent) emit(RequestState.error(failure.message));
    }
  }

  Future<void> acceptRequest(String requestId) async {
    emit(const RequestState.loading());
    final result = await _acceptRequestUseCase(
      RequestIdParams(requestId: requestId),
    );
    switch (result) {
      case Success(data: final data):
        emit(RequestState.requestUpdated(data));
        await getPendingRequests();
      case FailureResult(failure: final failure):
        emit(RequestState.error(failure.message));
    }
  }

  Future<void> completeRequest(String requestId) async {
    emit(const RequestState.loading());
    final result = await _completeRequestUseCase(
      RequestIdParams(requestId: requestId),
    );
    switch (result) {
      case Success(data: final data):
        emit(RequestState.requestUpdated(data));
        await getPendingRequests();
      case FailureResult(failure: final failure):
        emit(RequestState.error(failure.message));
    }
  }

  @override
  Future<void> close() {
    _realTimeService.offWaiterRequestCreated(_onWaiterRequestCreated);
    _realTimeService.offWaiterRequestUpdated(_onWaiterRequestUpdated);
    return super.close();
  }
}
