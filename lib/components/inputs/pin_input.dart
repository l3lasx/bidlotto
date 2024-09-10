import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatefulPinInputTextField extends StatefulWidget {
  const StatefulPinInputTextField({
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.initialFocusDelay = const Duration(seconds: 1),
    this.focusBorderColor = Colors.blue,
    this.borderColor = Colors.black12,
    this.obscuringCharacter = '•',
    this.fillColor = Colors.white,
    this.focusBorderWidth = 2.0,
    this.automaticFocus = true,
    required this.onChanged,
    required this.pinLength,
    this.obscureText = false,
    this.borderWidth = 1.0,
    this.contentPadding,
    this.filled = true,
    this.aspectRatio,
    this.focusBorder,
    this.boxShape,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: Colors.black,
      fontSize: 28,
    ),
    this.border,
    this.initialValue = '',
    super.key,
  })  : assert(
          (focusBorder != null && focusBorderWidth == 2.0) ||
              focusBorder == null,
          'focusBorderWidth must be null when focusBorder is not.',
        ),
        assert(
          (border != null && borderWidth == 1.0) || border == null,
          'borderWidth must be null when border is not.',
        ),
        assert(obscuringCharacter.length == 1),
        assert(pinLength > 0),
        assert(focusBorderWidth >= 0),
        assert(initialValue.length <= pinLength);

  final ValueChanged<String> onChanged;
  final Duration initialFocusDelay;
  final EdgeInsets? contentPadding;
  final BorderRadius borderRadius;
  final String obscuringCharacter;
  final double focusBorderWidth;
  final Color focusBorderColor;
  final Border? focusBorder;
  final bool automaticFocus;
  final double? aspectRatio;
  final TextStyle textStyle;
  final double borderWidth;
  final EdgeInsets padding;
  final Color borderColor;
  final BoxShape? boxShape;
  final bool obscureText;
  final Color fillColor;
  final Border? border;
  final int pinLength;
  final bool filled;
  final String initialValue;

  @override
  StatefulPinInputTextFieldState createState() =>
      StatefulPinInputTextFieldState();
}

class StatefulPinInputTextFieldState extends State<StatefulPinInputTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _rawKeyboardFocusNodes;
  late List<FocusNode> _textFocusNodes;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    try {
      _controllers = List.generate(
        widget.pinLength,
        (index) => TextEditingController(
          text: index < widget.initialValue.length
              ? widget.initialValue[index]
              : '',
        ),
      );
      _rawKeyboardFocusNodes =
          List.generate(widget.pinLength, (_) => FocusNode());
      _textFocusNodes = List.generate(widget.pinLength, (_) => FocusNode());

      for (var i = 0; i < widget.pinLength; i++) {
        _textFocusNodes[i].addListener(_focusNodeListener);
        _rawKeyboardFocusNodes[i].addListener(_focusNodeListener);
        _controllers[i].addListener(() {
          _controllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[i].text.length),
          );
        });
      }

      if (widget.automaticFocus) {
        Future.delayed(widget.initialFocusDelay).then((_) {
          if (mounted) {
            setState(() {
              _requestFocus(widget.initialValue.length);
            });
          }
        });
      }
    } catch (e) {
      print('Error in _initializeControllers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.aspectRatio == null
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.pinLength,
        (index) {
          Widget textField = AnimatedContainer(
            key: Key('AnimatedContainer${_controllers[index].hashCode}'),
            duration: const Duration(microseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.fillColor,
              border: border(index),
              borderRadius:
                  widget.boxShape == null ? widget.borderRadius : null,
              shape: widget.boxShape ?? BoxShape.rectangle,
            ),
            child: AbsorbPointer(
              absorbing: _absorbing(index),
              child: RawKeyboardListener(
                focusNode: _rawKeyboardFocusNodes[index],
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      _onChanged(index, '');
                    }
                  }
                },
                child: TextField(
                  key: Key('TextField${_controllers[index].hashCode}'),
                  onChanged: (value) => _onChanged(index, value),
                  obscuringCharacter: widget.obscuringCharacter,
                  keyboardType: TextInputType.number,
                  focusNode: _textFocusNodes[index],
                  controller: _controllers[index],
                  obscureText: widget.obscureText,
                  mouseCursor: MouseCursor.defer,
                  textAlign: TextAlign.center,
                  style: widget.textStyle,
                  onTap: _onTap,
                  decoration: InputDecoration(
                    contentPadding: widget.aspectRatio != null
                        ? EdgeInsets.zero
                        : widget.contentPadding,
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          );

          if (widget.aspectRatio != null) {
            textField = AspectRatio(
              aspectRatio: widget.aspectRatio!,
              child: textField,
            );
          }

          return Flexible(
            child: Padding(
              padding: widget.padding,
              child: textField,
            ),
          );
        },
      ),
    );
  }

  int get index {
    return _textFocusNodes.isNotEmpty
        ? _textFocusNodes.indexWhere((element) => element.hasFocus)
        : 0;
  }

  String get getPin => _controllers.map((controller) => controller.text).join();

  bool _absorbing(int index) {
    if (_textFocusNodes.any((element) => element.hasFocus)) {
      return !_textFocusNodes[index].hasFocus;
    }
    if (getPin.length == widget.pinLength) {
      return index < widget.pinLength - 1;
    }
    return index != 0;
  }

  void _onChanged(int index, String value) {
    try {
      if (index < 0) return;

      value = value.trim();
      if (value.isEmpty) {
        if (index > 0) {
          if (_controllers[index].value.text.isEmpty) {
            _requestFocus(index - 1);
          } else {
            _requestFocus(index);
          }
        }
      } else if (value.length == 1) {
        if (index < widget.pinLength - 1) {
          _requestFocus(index + 1);
        } else {
          _unFocus(index);
        }
      } else if (value.length > 1) {
        int nextIndex = index;
        final charList = value.split('');
        for (final char in charList) {
          if (nextIndex < widget.pinLength) {
            _controllers[nextIndex].text = char;
            nextIndex++;
          } else {
            break;
          }
        }
        if (nextIndex < widget.pinLength) {
          _requestFocus(nextIndex);
        } else {
          _unFocus();
        }
      }
      widget.onChanged.call(getPin);

      setState(() {});
    } catch (e) {
      print('Error in _onChanged: $e');
    }
  }

  void _requestFocus(int index) {
    try {
      _textFocusNodes[index].requestFocus();
    } catch (e) {
      print('Error in _requestFocus: $e');
    }
  }

  void _unFocus([int? index]) {
    try {
      if (index == null) {
        for (final element in _textFocusNodes) {
          element.unfocus();
        }
      } else {
        _textFocusNodes[index].unfocus();
      }
    } catch (e) {
      print('Error in _unFocus: $e');
    }
  }

  void _onTap() {
    try {
      setState(() {
        _requestFocus(index);
      });
    } catch (e) {
      print('Error in _onTap: $e');
    }
  }

  void _focusNodeListener() {
    try {
      setState(() {});
    } catch (e) {
      print('Error in _focusNodeListener: $e');
    }
  }

  Border border(int index) {
    try {
      return _textFocusNodes[index].hasFocus
          ? (widget.focusBorder ??
              Border.all(
                color: widget.focusBorderColor,
                width: widget.focusBorderWidth,
              ))
          : (widget.border ??
              Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ));
    } catch (e) {
      print('Error in border: $e');
      return Border.all(color: Colors.red); // Fallback border
    }
  }

  void setPin(String pin) {
    try {
      setState(() {
        for (var i = 0; i < widget.pinLength; i++) {
          _controllers[i].text = i < pin.length ? pin[i] : '';
        }
      });
      widget.onChanged.call(getPin);
    } catch (e) {
      print('Error in setPin: $e');
    }
  }

  @override
  void dispose() {
    try {
      for (var i = 0; i < widget.pinLength; i++) {
        _rawKeyboardFocusNodes[i].removeListener(_focusNodeListener);
        _rawKeyboardFocusNodes[i].dispose();
        _textFocusNodes[i].removeListener(_focusNodeListener);
        _textFocusNodes[i].dispose();
        _controllers[i].dispose();
      }
    } catch (e) {
      print('Error in dispose: $e');
    }
    super.dispose();
  }
}