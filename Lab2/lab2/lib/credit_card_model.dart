class CreditCardModel {

  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName, this.cvvCode, this.isCvvFocused, this.expiryMonth);

  String cardNumber = '';
  String expiryDate = '';
  String expiryMonth = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
}
