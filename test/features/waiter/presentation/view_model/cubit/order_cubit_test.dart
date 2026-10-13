import 'package:bloc_test/bloc_test.dart';
import 'package:dineflow/core/usecases/no_params.dart';
import 'package:dineflow/core/usecases/result.dart';
import 'package:dineflow/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:dineflow/features/waiter/domain/entity/create_dine_order_params.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/create_order_takeaway.dart';
import 'package:dineflow/features/waiter/domain/entity/order_waiter_entity.dart';
import 'package:dineflow/features/waiter/domain/entity/waiter_request_entity.dart';
import 'package:dineflow/features/waiter/domain/use_case/order_id_params.dart';
import 'package:dineflow/features/waiter/presentation/view_model/cubit/order_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_dine_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/create_takeaway_order_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_order_by_id_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/get_orders_by_status_use_case.dart';
import 'package:dineflow/features/waiter/domain/use_case/update_order_status_use_case.dart';
import 'package:mockito/mockito.dart';

import 'order_cubit_test.mocks.dart';

@GenerateMocks([
  CreateDineOrderUseCase,
  CreateTakeAwayOrderUseCase,
  GetOrdersUseCase,
  GetOrdersByStatusUseCase,
  GetOrderByIdUseCase,
  UpdateOrderStatusUseCase,
])
void main() {
  late MockCreateDineOrderUseCase createDineOrderUseCase;
  late MockCreateTakeAwayOrderUseCase createTakeAwayOrderUseCase;
  late MockGetOrdersUseCase getOrdersUseCase;
  late MockGetOrdersByStatusUseCase getOrdersByStatusUseCase;
  late MockGetOrderByIdUseCase getOrderByIdUseCase;
  late MockUpdateOrderStatusUseCase updateOrderStatusUseCase;
  setUpAll(() {
    provideDummy<Result<CreateOrderEntity>>(
      Success<CreateOrderEntity>(
        CreateOrderEntity(
          orderId: '1235',
          orderNumber: '12345',
          orderType: 'DINE_IN',
          items: [],
          subtotal: 0,
          tax: 0,
          total: 0,
          status: 'PENDING',
          createdAt: DateTime(2026),
        ),
      ),
    );
    provideDummy<Result<OrderWaiterEntity>>(
      Success<OrderWaiterEntity>(
        OrderWaiterEntity(
          id: '123',
          orderNumber: '123',
          customer: CustomerEntity(id: '12345', name: 'name'),
          type: 'DINE_IN',
          items: [],
          status: 'pending',
          subtotal: 10,
          tax: 20,
          total: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
  });
  setUp(() {
    createDineOrderUseCase = MockCreateDineOrderUseCase();
    createTakeAwayOrderUseCase = MockCreateTakeAwayOrderUseCase();
    getOrdersUseCase = MockGetOrdersUseCase();
    getOrdersByStatusUseCase = MockGetOrdersByStatusUseCase();
    getOrderByIdUseCase = MockGetOrderByIdUseCase();
    updateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
  });

  const params = CreateDineOrderParams(diningSessionId: '1235', items: []);
  final order = CreateOrderEntity(
    orderId: '1235',
    orderNumber: '12345',
    orderType: 'dine',
    items: [],
    subtotal: 0,
    tax: 0,
    total: 0,
    status: 'pending',
    createdAt: DateTime.now(),
  );
  blocTest<OrderCubit, OrderState>(
    'Create dine order states',
    build: () {
      when(
        createDineOrderUseCase(params),
      ).thenAnswer((_) async => Success<CreateOrderEntity>(order));
      return OrderCubit(
        createDineOrderUseCase,
        createTakeAwayOrderUseCase,
        getOrdersUseCase,
        getOrdersByStatusUseCase,
        getOrderByIdUseCase,
        updateOrderStatusUseCase,
      );
    },
    act: (cubit) => cubit.createDineOrder(params),
    expect: () => [OrderState.loading(), OrderState.orderCreated(order)],
  );

  final paramsTakeAway = CreateTakeAwayOrderParams(items: []);

  blocTest(
    'create take away order',
    build: () {
      when(
        createTakeAwayOrderUseCase(paramsTakeAway),
      ).thenAnswer((_) async => Success<CreateOrderEntity>(order));
      return OrderCubit(
        createDineOrderUseCase,
        createTakeAwayOrderUseCase,
        getOrdersUseCase,
        getOrdersByStatusUseCase,
        getOrderByIdUseCase,
        updateOrderStatusUseCase,
      );
    },
    act: (cubit) => cubit.createTakeawayOrder(paramsTakeAway),
    expect: () => [OrderState.loading(), OrderState.orderCreated(order)],
  );

  final orderparams = OrderIdParams(orderId: '1235');
  final orderData = OrderWaiterEntity(
    id: '123',
    orderNumber: '123',
    customer: CustomerEntity(id: '12345', name: 'name'),
    type: 'DINE_IN',
    items: [],
    status: 'pending',
    subtotal: 10,
    tax: 20,
    total: 30,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  blocTest(
    'get order by id',
    build: () {
      when(
        getOrderByIdUseCase(any),
      ).thenAnswer((_) async => Success<OrderWaiterEntity>(orderData));
      return OrderCubit(
        createDineOrderUseCase,
        createTakeAwayOrderUseCase,
        getOrdersUseCase,
        getOrdersByStatusUseCase,
        getOrderByIdUseCase,
        updateOrderStatusUseCase,
      );
    },
    act: (cubit) => cubit.getOrderById('1235'),
    expect: () => [OrderState.loading(), OrderState.orderLoaded(orderData)],
  );
}
