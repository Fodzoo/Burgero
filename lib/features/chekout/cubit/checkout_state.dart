
enum CheckoutStatus {
  initial,
  loading,
  success,
  failure,
}

class CheckoutState {
  final CheckoutStatus status;
  final String selectedMethod;
  final bool saveCardDetails;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.selectedMethod = 'Cash',
    this.saveCardDetails = false,
    this.errorMessage,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? selectedMethod,
    bool? saveCardDetails,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      saveCardDetails: saveCardDetails ?? this.saveCardDetails,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
