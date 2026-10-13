part of 'request_cubit.dart';

@freezed
class RequestState with _$RequestState {
  const factory RequestState.initial() = _Initial;
  const factory RequestState.loading() = _Loading;
  const factory RequestState.error(String error) = _Error;
  const factory RequestState.requestsLoaded(WaiterRequestsPageEntity data) =
      _RequestsLoaded;
  const factory RequestState.requestUpdated(WaiterRequestEntity data) =
      _RequestUpdated;
}
