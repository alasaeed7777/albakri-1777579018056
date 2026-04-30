```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _isNewInput = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewInput) {
        _display = digit;
        _isNewInput = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      final current = double.tryParse(_display) ?? 0.0;
      if (_operator != null && !_isNewInput) {
        _performCalculation();
      }
      _firstOperand = double.tryParse(_display) ?? 0.0;
      _operator = op;
      _expression = '$_display $op ';
      _isNewInput = true;
    });
  }

  void _performCalculation() {
    final secondOperand = double.tryParse(_display) ?? 0.0;
    double result;
    switch (_operator) {
      case '+':
        result = (_firstOperand ?? 0) + secondOperand;
        break;
      case '-':
        result = (_firstOperand ?? 0) - secondOperand;
        break;
      case 'Ã':
        result = (_firstOperand ?? 0) * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0
            ? (_firstOperand ?? 0) / secondOperand
            : double.nan;
        break;
      default:
        result = secondOperand;
    }
    _display = result.isNaN ? 'Ø®Ø·Ø£' : result.toStringAsFixed(10).replaceAll(RegExp(r'\.?0+$'), '');
    _expression = '$_expression $secondOperand =';
    _firstOperand = result.isNaN ? null : result;
    _operator = null;
    _isNewInput = true;
  }

  void _onEqualsPressed() {
    if (_operator != null) {
      setState(() {
        _performCalculation();
      });
    }
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewInput = true;
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final value = double.tryParse(_display) ?? 0.0;
      _display = (value / 100).toStringAsFixed(10).replaceAll(RegExp(r'\.?0+$'), '');
    });
  }

  void _onToggleSignPressed() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
        _isNewInput = false;
      }
    });
  }

  Widget _buildButton(String text, {Color? color, double flex = 1}) {
    final isOperator = ['+', '-', 'Ã', 'Ã·', '='].contains(text);
    final isNumber = RegExp(r'^[0-9]$').hasMatch(text);
    final isAction = ['C', '%', 'Â±'].contains(text);

    Color buttonColor;
    Color textColor;
    if (isOperator) {
      buttonColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
    } else if (isAction) {
      buttonColor = Theme.of(context).colorScheme.secondaryContainer;
      textColor = Theme.of(context).colorScheme.onSecondaryContainer;
    } else if (text == '0') {
      buttonColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).colorScheme.onSurface;
    } else {
      buttonColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: () {
              if (isNumber) {
                _onDigitPressed(text);
              } else if (text == '.') {
                _onDecimalPressed();
              } else if (text == 'C') {
                _onClearPressed();
              } else if (text == '=') {
                _onEqualsPressed();
              } else if (text == '%') {
                _onPercentagePressed();
              } else if (text == 'Â±') {
                _onToggleSignPressed();
              } else {
                _onOperatorPressed(text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C'),
                    _buildButton('Â±'),
                    _buildButton('%'),
                    _buildButton('Ã·'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('Ã'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', flex: 2),
                    _buildButton('.'),
                    _buildButton('='),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```