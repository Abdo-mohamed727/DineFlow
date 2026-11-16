class PendingOrder {
  const PendingOrder({
    required this.clientOrderId,
    required this.payload,
    required this.createdAt,
    this.status = PendingOrderStatus.pending,
    this.retryCount = 0,
    this.lastError,
    this.serverOrderId,
  });

  final String clientOrderId;
  final Map<String, dynamic> payload;
  final PendingOrderStatus status;
  final int retryCount;
  final DateTime createdAt;
  final String? lastError;
  final String? serverOrderId;

  PendingOrder copyWith({
    PendingOrderStatus? status,
    int? retryCount,
    String? lastError,
    bool clearLastError = false,
    String? serverOrderId,
  }) {
    return PendingOrder(
      clientOrderId: clientOrderId,
      payload: payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt,
      lastError: clearLastError ? null : lastError ?? this.lastError,
      serverOrderId: serverOrderId ?? this.serverOrderId,
    );
  }
}

enum PendingOrderStatus { pending, sending, failed }
