import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatefulWidget {
  final bool forceValidation;
  final void Function(String otp) onOtpChanged;
  const OtpInputField({
    super.key,
    this.forceValidation = false,
    required this.onOtpChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<ValueNotifier<bool>> _wasFocusedNotifiers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _wasFocusedNotifiers = List.generate(
      6,
      (index) => ValueNotifier<bool>(false),
    );

    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _wasFocusedNotifiers[i].value = true;
        }
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var notifier in _wasFocusedNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          height: 60,
          width: 48,
          child: ValueListenableBuilder<bool>(
            valueListenable: _wasFocusedNotifiers[index],
            builder: (context, wasFocused, child) {
              return TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                onChanged: (value) {
                  if (value.length == 1 && index < 5) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  }
                  if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  }
                  final otp = _controllers.map((c) => c.text).join();
                  widget.onOtpChanged(otp);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1D4ED8)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  // Only show error if was focused OR if forced by parent (e.g. Sign In clicked)
                  if (!wasFocused && !widget.forceValidation) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return ''; // Highlight the box
                  }
                  return null;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
