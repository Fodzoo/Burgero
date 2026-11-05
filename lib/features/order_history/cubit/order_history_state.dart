class OrderHistoryState {
  final List<Map<String, dynamic>> orders;
  final bool isLoading;
  final String? errorMessage;
  final Set<String> deletingItems;
  final String? successMessage;
  final String? deleteErrorMessage;

  const OrderHistoryState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
    this.deletingItems = const {},
    this.successMessage,
    this.deleteErrorMessage,
  });

  OrderHistoryState copyWith({
    List<Map<String, dynamic>>? orders,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    Set<String>? deletingItems,
    String? successMessage,
    String? deleteErrorMessage,
    bool clearMessages = false,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      deletingItems: deletingItems ?? this.deletingItems,
      successMessage: clearMessages
          ? null
          : successMessage ?? this.successMessage,
      deleteErrorMessage: clearMessages
          ? null
          : deleteErrorMessage ?? this.deleteErrorMessage,
    );
  }
}
