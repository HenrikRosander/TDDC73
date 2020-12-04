import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.expiryMonth,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String expiryMonth;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  String expiryMonth;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
  MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _cardHolderNameController =
  TextEditingController();
  final TextEditingController _expiryDateController =
  MaskedTextController(mask: '00/00');
  final TextEditingController _cvvCodeController =
  MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';
    expiryMonth = widget.expiryMonth ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused,
        expiryMonth);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme
        .of(context)
        .primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.2),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _cardNumberController,
                initialValue: 'Input text',
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card number',
                  // initialValue: 'Input text',
                  // hintText: 'xxxx xxxx xxxx xxxx',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Name',
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
            ),

       Container(
         child: Row(
           children: <Widget>[
             Container(
               padding: const EdgeInsets.only(left: 24, right: 26, top: 8),
               // decoration: BoxDecoration(
               //     borderRadius: BorderRadius.circular(2.0),
               //     border: Border.all(color: Colors.black)),
               child : SizedBox(
                  width: 80,
                 child: DropdownButton<String>(

                   hint: Text('Month'),
                   items: <int>[01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12]
                       .map((int value) {
                     return new DropdownMenuItem<String>(
                       value: value.toString(),
                       child: new Text(value.toString()),
                     );
                   }).toList(),
                   onChanged: (value) {
                     setState(() {
                       if (int.parse(value) < 10) {
                         value = '0' + value;
                       }
                       expiryMonth = value;
                       creditCardModel.expiryMonth = expiryMonth;
                       onCreditCardModelChange(creditCardModel);
                     });
                   },
                 ),
               ),
             ),
             Container(
               padding:const EdgeInsets.only(left: 16, right: 26, top: 8),
               // decoration: BoxDecoration(
               //   borderRadius: BorderRadius.circular(8.0),
               //   border: Border.all(
               //       color: Colors.black, style: BorderStyle.solid, width: 0.60),
               // ),
               child: SizedBox(
                width: 80,
                 child: DropdownButton<String>(

                   hint: Text('Year'),
                   items: <int>[20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
                       .map((int value) {
                     return new DropdownMenuItem<String>(
                       value: value.toString(),
                       child: new Text(value.toString()),
                     );
                   }).toList(),
                   onChanged: (value) {
                     setState(() {
                       expiryDate = value;
                       creditCardModel.expiryDate = expiryDate;
                       onCreditCardModelChange(creditCardModel);
                     });

                   },

                 ),
               ),
             ),
             Container(
               padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
               child : SizedBox(
                 width: 126,
                 child: TextField(
                   focusNode: cvvFocusNode,
                   controller: _cvvCodeController,
                   cursorColor: widget.cursorColor ?? themeColor,
                   style: TextStyle(
                     color: widget.textColor,
                   ),
                   decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: 'CVV',
                     hintText: 'XXXX',
                   ),
                   keyboardType: TextInputType.number,
                   textInputAction: TextInputAction.done,
                   onChanged: (String text) {
                     setState(() {
                       cvvCode = text;
                     });
                   },
                 ),
               ),
             ),
           ],
         ),
       ),
      ],
      ),
      ),
      );

  }
}
