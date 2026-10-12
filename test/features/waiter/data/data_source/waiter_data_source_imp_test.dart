import 'package:dineflow/core/networking/api_constants.dart';
import 'package:dineflow/features/waiter/data/data_source/waiter_data_source_imp.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'waiter_data_source_imp_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  MockDio mockDio = MockDio();
  final dataSource = WaiterDataSourceImpl(mockDio);
  test('Create take away order', () async {
    final items = [
      {
        'productId': '1',
        'quantity': 2,
        'productName': 'Pizza',
        'unitPrice': 10.0,
        'subtotal': 20.0,
      },
    ];
    when(
      mockDio.post(
        ApiConstants.createOrder,
        data: {'orderType': 'TAKEAWAY', 'items': items},
      ),
    ).thenAnswer(
      (_) async => Response(
        data: {
          'data': {
            'orderId': '123',
            'order': {'orderNumber': '456', 'notes': 'Please make it spicy'},

            'orderType': 'TAKEAWAY',
            'items': items,

            'subtotal': 100.0,
            'tax': 10.0,
            'total': 110.0,
            'status': 'pending',
            'createdAt': '2023-01-01T00:00:00Z',
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiConstants.createOrder),
      ),
    );
    final response = await dataSource.createTakeAwayOrder(items);

    expect(response.orderId, '123');
    expect(response.orderNumber, '456');
    expect(response.orderType, 'TAKEAWAY');
    expect(response.total, 110.0);

    verify(
      mockDio.post(
        ApiConstants.createOrder,
        data: {'orderType': 'TAKEAWAY', 'items': items},
      ),
    ).called(1);
  });
  test('update order success ', () async {
    MockDio mockDio = MockDio();
    final dataSource = WaiterDataSourceImpl(mockDio);

    const orderId = '123';
    const status = 'completed';

    when(
      mockDio.patch(
        "${ApiConstants.orders}/$orderId/status",
        data: argThat(equals({'status': status}), named: 'data'),
      ),
    ).thenAnswer(
      (_) async => Response(
        data: {
          'data': {
            'order': {
              'id': orderId,
              'orderNumber': '456',
              'status': status,
              'createdAt': '2023-01-01T00:00:00Z',
              'updatedAt': '2023-01-01T00:00:00Z',
            },
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(
          path: '${ApiConstants.orders}/$orderId/status',
        ),
      ),
    );

    final res = await dataSource.updateOrderStatus(orderId, status);

    expect(res.id, '123');
    expect(res.status, 'completed');
    expect(res.orderNumber, '456');
    expect(res.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
    expect(res.updatedAt, DateTime.parse('2023-01-01T00:00:00Z'));
    final captured = verify(
      mockDio.patch(
        '${ApiConstants.orders}/$orderId/status',
        data: captureAnyNamed('data'),
      ),
    ).captured;

    expect(captured.single, equals({'status': status}));
  });

  test('get Avaliacle tables', () async {
    when(
      mockDio.get(
        ApiConstants.tables,
        queryParameters: {'status': 'available'},
      ),
    ).thenAnswer(
      (_) async => Response(
        data: {
          'data': {
            'tables': [
              {
                'id': '1',
                'tableNumber': 1,
                'capacity': 4,
                'isAvailable': true,
                'updatedAt': '2023-01-01T00:00:00Z',
                'createdAt': '2023-01-01T00:00:00Z',
              },
              {
                'id': '2',
                'tableNumber': 2,
                'capacity': 4,
                'isAvailable': true,
                'updatedAt': '2023-01-01T00:00:00Z',
                'createdAt': '2023-01-01T00:00:00Z',
              },
            ],
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiConstants.tables),
      ),
    );

    final res = await dataSource.getAvailableTables();

    expect(res.tables.length, 2);
    expect(res.tables[0].id, '1');
    expect(res.tables[0].tableNumber, 1);
    expect(res.tables[0].capacity, 4);
    expect(res.tables[1].id, '2');
    expect(res.tables[1].tableNumber, 2);
    expect(res.tables[1].capacity, 4);
    expect(res.tables[0].updatedAt, DateTime.parse('2023-01-01T00:00:00Z'));
    expect(res.tables[0].createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
    expect(res.tables[1].updatedAt, DateTime.parse('2023-01-01T00:00:00Z'));
    expect(res.tables[1].createdAt, DateTime.parse('2023-01-01T00:00:00Z'));

    verify(
      mockDio.get(
        ApiConstants.tables,
        queryParameters: {'status': 'available'},
      ),
    ).called(1);
  });
 
  
}
