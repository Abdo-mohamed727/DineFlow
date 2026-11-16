import 'package:dineflow/features/orders/domain/entity/pending_order.dart';
import 'package:dineflow/features/orders/presentation/view/widgets/pending_orders_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PendingOrder createOrder(PendingOrderStatus status, {String? lastError}) {
    return PendingOrder(
      clientOrderId: '4a0f4bb1-2040-4ed1-9030-42c6feb7eb34',
      payload: const {'orderType': 'TAKEAWAY'},
      status: status,
      createdAt: DateTime.utc(2026, 11, 15),
      lastError: lastError,
    );
  }

  Widget createApp({
    required PendingOrder order,
    required ValueChanged<String> onRetry,
    required ValueChanged<String> onDiscard,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: PendingOrdersSection(
            orders: [order],
            onRetry: onRetry,
            onDiscard: onDiscard,
          ),
        ),
      ),
    );
  }

  testWidgets('pending order displays its badge without failed actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      createApp(
        order: createOrder(PendingOrderStatus.pending),
        onRetry: (_) {},
        onDiscard: (_) {},
      ),
    );

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Order saved on this device'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
    expect(find.text('Discard'), findsNothing);
  });

  testWidgets('failed order displays its error and retry/discard actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      createApp(
        order: createOrder(
          PendingOrderStatus.failed,
          lastError: 'Item unavailable',
        ),
        onRetry: (_) {},
        onDiscard: (_) {},
      ),
    );

    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Item unavailable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Discard'), findsOneWidget);
  });

  testWidgets('retry and discard actions return the order id', (tester) async {
    String? retriedId;
    String? discardedId;
    final order = createOrder(PendingOrderStatus.failed);
    await tester.pumpWidget(
      createApp(
        order: order,
        onRetry: (id) => retriedId = id,
        onDiscard: (id) => discardedId = id,
      ),
    );

    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Discard'));

    expect(retriedId, order.clientOrderId);
    expect(discardedId, order.clientOrderId);
  });
}
