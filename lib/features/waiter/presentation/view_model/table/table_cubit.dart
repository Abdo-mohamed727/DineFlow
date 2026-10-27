import 'package:bloc/bloc.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/usecase/close_dining_session_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/get_active_dining_sessions_usecase.dart';
import 'package:dineflow/features/orders/domain/usecase/get_available_tables_usecase.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_table_by_id_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_tables_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/table_id_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_table_params.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_table_use_case.dart';
import 'package:dineflow/features/waiter/presentation/view_model/table/table_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class TableCubit extends Cubit<TableState> {
  final GetTablesUseCase _getTablesUseCase;
  final GetAvailableTablesUseCase _getAvailableTablesUseCase;
  final GetTableByIdUseCase _getTableByIdUseCase;
  final UpdateTableUseCase _updateTableUseCase;
  final GetActiveDiningSessionsUseCase _getActiveDiningSessionsUseCase;
  final CloseDiningSessionUseCase _closeDiningSessionUseCase;

  TableCubit(
    this._getTablesUseCase,
    this._getAvailableTablesUseCase,
    this._getTableByIdUseCase,
    this._updateTableUseCase,
    this._getActiveDiningSessionsUseCase,
    this._closeDiningSessionUseCase,
  ) : super(const TableState());

  Future<void> getTables({bool showLoading = true}) async {
    if (showLoading) {
      emit(state.copyWith(status: TableStatus.loading, errorMessage: null));
    }
    final result = await _getTablesUseCase(const NoParams());
    switch (result) {
      case Success(data: final data):
        emit(
          state.copyWith(
            status: TableStatus.success,
            tables: data,
            errorMessage: null,
          ),
        );
      case FailureResult(failure: final failure):
        emit(
          state.copyWith(
            status: TableStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> getAvailableTables() async {
    emit(state.copyWith(status: TableStatus.loading, errorMessage: null));
    final result = await _getAvailableTablesUseCase(const NoParams());
    switch (result) {
      case Success(data: final data):
        emit(
          state.copyWith(status: TableStatus.success, availableTables: data),
        );
      case FailureResult(failure: final failure):
        emit(
          state.copyWith(
            status: TableStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> getTableById(String tableId) async {
    emit(state.copyWith(status: TableStatus.loading, errorMessage: null));
    final result = await _getTableByIdUseCase(TableIdParams(tableId: tableId));
    switch (result) {
      case Success(data: final data):
        emit(state.copyWith(status: TableStatus.success, selectedTable: data));
      case FailureResult(failure: final failure):
        emit(
          state.copyWith(
            status: TableStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> updateTable(
    String tableId,
    String status, {
    bool availableOnly = false,
  }) async {
    emit(
      state.copyWith(
        status: TableStatus.loading,
        errorMessage: null,
        updated: false,
      ),
    );
    final result = await _updateTableUseCase(
      UpdateTableParams(tableId: tableId, status: status),
    );
    switch (result) {
      case Success(data: final data):
        emit(
          state.copyWith(
            status: TableStatus.success,
            selectedTable: data,
            updated: true,
          ),
        );
        // Refresh the list, keeping `updated: true` for the listener.
        if (availableOnly) {
          await getAvailableTables();
        } else {
          await getTables();
        }
      case FailureResult(failure: final failure):
        emit(
          state.copyWith(
            status: TableStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> closeDiningSession(String tableId) async {
    if (state.closingSession) return;

    emit(
      state.copyWith(
        errorMessage: null,
        updated: false,
        closingSession: true,
        closingTableId: tableId,
        sessionClosed: false,
      ),
    );

    final sessionsResult = await _getActiveDiningSessionsUseCase(
      const NoParams(),
    );
    switch (sessionsResult) {
      case FailureResult(failure: final failure):
        emit(
          state.copyWith(
            closingSession: false,
            closingTableId: '',
            errorMessage: failure.message,
          ),
        );
        return;
      case Success(data: final sessions):
        final matchingSessions = sessions.where(
          (session) =>
              session.tableId == tableId &&
              session.status.toLowerCase() == 'active',
        );
        if (matchingSessions.isEmpty) {
          emit(
            state.copyWith(
              closingSession: false,
              closingTableId: '',
              errorMessage: 'No active dining session exists for this table.',
            ),
          );
          return;
        }

        final closeResult = await _closeDiningSessionUseCase(
          matchingSessions.first.id,
        );
        switch (closeResult) {
          case FailureResult(failure: final failure):
            emit(
              state.copyWith(
                closingSession: false,
                closingTableId: '',
                errorMessage: failure.message,
              ),
            );
          case Success(data: final session):
            if (session.status.toLowerCase() != 'closed') {
              emit(
                state.copyWith(
                  closingSession: false,
                  closingTableId: '',
                  errorMessage: 'The dining session was not closed.',
                ),
              );
              return;
            }
            emit(
              state.copyWith(
                status: TableStatus.success,
                closingSession: false,
                closingTableId: '',
                errorMessage: null,
                updated: true,
                sessionClosed: true,
              ),
            );
            await getTables(showLoading: false);
        }
    }
  }
}
