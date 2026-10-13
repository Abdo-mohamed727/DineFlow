import 'package:bloc_test/bloc_test.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/domain/entity/table_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:dineflow/features/waiter/domain/use_case/accept_request_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_pending_requests_use_case.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/waiter_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'waiter_cubit_test.mocks.dart';

@GenerateMocks([AcceptRequestUseCase, GetPendingRequestsUseCase])
void main() {
  late MockAcceptRequestUseCase mockAcceptRequestUseCase;
  late MockGetPendingRequestsUseCase mockGetPendingRequestsUseCase;

  setUp(() {
    mockAcceptRequestUseCase = MockAcceptRequestUseCase();
    mockGetPendingRequestsUseCase = MockGetPendingRequestsUseCase();
  });
  final data = WaiterRequestEntity(
    id: 'request-123',
    customer: CustomerEntity(id: 'customer-123', name: 'John Doe'),
    table: TableEntity(
      id: 'table-123',
      tableNumber: 12,
      capacity: 4,
      status: 'available',
      location: 'window',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    diningSessionId: 'session-123',
    type: 'type-123',
    status: 'status-123',
    message: 'message-123',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    handledBy: 'handled-by-123',
    handledAt: DateTime.now(),
  );
  blocTest<WaiterCubit, WaiterState>(
    'emits loading, requestUpdated, loading, requestsLoaded '
    'when accepting request succeeds',

    build: () {
      when(
        mockAcceptRequestUseCase(any),
      ).thenAnswer((_) async => Success(data));

      when(mockGetPendingRequestsUseCase(any)).thenAnswer(
        (_) async => Success(
          WaiterRequestsPageEntity(
            items: [data],
            total: 11,
            page: 11,
            limit: 10,
            totalPages: 2,
          ),
        ),
      );

      return WaiterCubit(
        getPendingRequestsUseCase: getPendingRequestsUseCase,
        acceptRequestUseCase: acceptRequestUseCase,
        completeRequestUseCase: completeRequestUseCase,
        createDineOrderUseCase: createDineOrderUseCase,
        createTakeawayOrderUseCase: createTakeawayOrderUseCase,
        getOrdersUseCase: getOrdersUseCase,
        getOrdersByStatusUseCase: getOrdersByStatusUseCase,
        getOrderByIdUseCase: getOrderByIdUseCase,
        updateOrderStatusUseCase: updateOrderStatusUseCase,
        getTablesUseCase: getTablesUseCase,
        getAvailableTablesUseCase: getAvailableTablesUseCase,
        getTableByIdUseCase: getTableByIdUseCase,
        updateTableUseCase: updateTableUseCase,
      );
    },
    act: (cubit) => cubit.acceptRequest('request-123'),
    expect: () => [
      const WaiterState.loading(),
      WaiterState.requestUpdated(data),
      const WaiterState.loading(),
      WaiterState.requestsLoaded(
        WaiterRequestsPageEntity(
          items: [data],
          total: 11,
          page: 11,
          limit: 10,
          totalPages: 2,
        ),
      ),
    ],
  );
}
