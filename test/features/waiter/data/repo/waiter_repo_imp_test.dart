import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_imp.dart';
import 'package:dineflow/features/waiter/data/models/create_order_model.dart';
import 'package:dineflow/features/waiter/data/models/customer_model.dart';
import 'package:dineflow/features/waiter/data/models/order_model.dart';
import 'package:dineflow/features/waiter/data/models/orders_page_model.dart';
import 'package:dineflow/features/waiter/data/models/table_model.dart';
import 'package:dineflow/features/waiter/data/models/waiter_request_model.dart';
import 'package:dineflow/features/waiter/data/models/waiter_request_page_model.dart';
import 'package:dineflow/features/waiter/data/repo/waiter_repo_imp.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/orders_page_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_page_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'waiter_repo_imp_test.mocks.dart';

@GenerateMocks([WaiterDataSourceImpl])
void main() {
  final mockWaiterDataSource = MockWaiterDataSourceImpl();
  final repo = WaiterRepositoryImpl(mockWaiterDataSource);

  testWidgets('waiter repo imp ...', (tester) async {
    final model = WaiterRequestsPageModel(
      items: [
        WaiterRequestModel(
          id: '1',

          status: 'pending',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
          customer: CustomerModel(id: '1', name: 'abdo'),
          table: TableModel(
            id: '2',
            tableNumber: 1,
            capacity: 4,
            status: 'available',
            location: 'window',
          ),
          diningSessionId: '',
          type: "DINE_IN",
          message: '',
        ),
      ],
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 1,
    );

    when(
      mockWaiterDataSource.getPendingRequests(),
    ).thenAnswer((_) async => model);

    final result = await repo.getPendingRequests();

    expect(result, isA<Success<WaiterRequestsPageEntity>>());
    verify(mockWaiterDataSource.getPendingRequests()).called(1);
  });

  test('accept Request done', () async {
    final model = WaiterRequestModel(
      id: '1',
      customer: CustomerModel(id: '1', name: 'abdo'),
      table: TableModel(
        id: '2',
        tableNumber: 1,
        capacity: 4,
        status: 'available',
        location: 'window',
      ),
      diningSessionId: '',
      type: 'DINE_IN',
      status: 'pending',
      message: '',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );
    when(
      mockWaiterDataSource.acceptRequest('1'),
    ).thenAnswer((_) async => model);
    final result = await repo.acceptRequest('1');
    expect(result, isA<Success<WaiterRequestEntity>>());
    verify(mockWaiterDataSource.acceptRequest('1')).called(1);
  });
  test('create dine in order', () async {
    const params = CreateDineOrderParams(
      diningSessionId: 'session-123',
      items: [OrderItemParams(productId: '1', quantity: 2)],
      notes: 'No onions',
    );
    final model = CreateOrderModel(
      orderId: '1',
      orderNumber: '123',
      orderType: 'DINE_IN',
      items: [
        OrderItemModel(
          productId: '1',
          productName: 'pizza',
          quantity: 2,
          unitPrice: 10.2,
          subtotal: 20.4,
        ),
      ],
      subtotal: 100,
      tax: 10,
      total: 110,
      status: 'pending',
      createdAt: DateTime(2023, 1, 1),
    );
    when(
      mockWaiterDataSource.createDineOrder(
        'session-123',
        argThat(
          equals([
            {'productId': '1', 'quantity': 2},
          ]),
        ),
        'No onions',
      ),
    ).thenAnswer((_) async => model);
    final result = await repo.createDineOrder(params);
    expect(result, isA<Success<CreateOrderEntity>>());
    verify(
      mockWaiterDataSource.createDineOrder(
        'session-123',
        argThat(
          equals([
            {'productId': '1', 'quantity': 2},
          ]),
        ),
        'No onions',
      ),
    ).called(1);
  });

  test('get order by status', () async {
    final model = OrdersPageModel(
      items: [
        OrderModel(
          id: '1',
          orderNumber: '123',
          customer: CustomerModel(id: '1', name: 'abdo'),
          type: 'DINE_IN',
          items: [
            OrderItemWaiterModel(
              productId: '1',
              productName: 'pizza',
              quantity: 2,
              unitPrice: 10.2,
              subtotal: 20.4,
            ),
          ],
          status: 'pending',
          subtotal: 100,
          tax: 10,
          total: 110,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      ],
      total: 1,
      page: 1,
      limit: 10,
      totalPages: 1,
    );
    when(
      mockWaiterDataSource.getOrdersByStatus('pending'),
    ).thenAnswer((_) async => model);
    final result = await repo.getOrdersByStatus('pending');
    expect(result, isA<Success<OrdersPageEntity>>());
    verify(mockWaiterDataSource.getOrdersByStatus('pending')).called(1);
  });
}
