/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

import 'package:flutter/cupertino.dart';
import 'package:iglu_ory_kratos_example/importer.dart';

class MTextField extends StatefulWidget {
  const MTextField({
    this.isEditable = true,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.check = true,
    this.showIcon = true,
    this.isFocusable = true,
    this.onTap,
    this.controller,
    this.isEnabled = true,
    this.focusNode,
    this.textColor,
    this.hintColor,
    this.digitsOnly = false,
    this.showCounter = false,
    this.isDate = false,
    this.lineVisible = true,
    this.cap = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.hint,
    this.type,
    this.borderColor,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines = 1,
    this.borderWidth = 0,
    this.maxLength,
    this.textSize = 15,
    this.style,
    this.hintStyle,
    this.bgRadius,
    this.helperText,
    this.autocorrect = false,
    this.tfPadding = const EdgeInsets.only(top: 10, bottom: 10),
    this.bgPadding = EdgeInsets.zero,
    this.enableSuggestions = false,
    this.enableInteractiveSelection = true,
    this.validator,
    this.toolbarOptions,
    this.showCursor = true,
    this.autofocus = false,
    this.autofillHints,
    this.textInputAction,
    this.backgroundColor,
    this.showClear = false,
    this.onFocusChanged,
    this.inputDecoration,
    this.labelText,
    this.cursorColor,
    Key? key,
  }) : super(key: key);

  final String? hint;
  final bool obscureText;
  final bool isEditable;
  final bool isEnabled;
  final bool isFocusable;
  final bool digitsOnly;
  final bool check;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? textColor;
  final Color? hintColor;
  final double textSize;
  final bool lineVisible;
  final bool isDate;
  final bool showIcon;
  final bool showCounter;
  final double borderWidth;
  final Color? borderColor;
  final TextInputType? type;
  final TextCapitalization cap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets tfPadding;
  final EdgeInsets bgPadding;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final double? bgRadius;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final bool enableSuggestions;
  final bool autocorrect;
  final Function(String)? validator;
  final bool enableInteractiveSelection;
  final ToolbarOptions? toolbarOptions;
  final bool showCursor;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final bool showClear;
  final Function(bool)? onFocusChanged;
  final Color? backgroundColor;
  final InputDecoration? inputDecoration;
  final String? labelText;
  final Color? cursorColor;

  @override
  MTextFieldState createState() => MTextFieldState();
}

class MTextFieldState extends State<MTextField> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.onFocusChanged != null) {
      focusNode.addListener(() {
        widget.onFocusChanged!(focusNode.hasFocus);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.check ? widget.borderColor ?? Colors.grey : Colors.red,
          width: widget.borderWidth,
        ),
      ),
      child: returnTF(),
    );
  }

  Widget returnTF() {
    return TextFormField(
      focusNode: widget.focusNode ?? focusNode,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      obscureText: widget.obscureText,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      enabled: widget.isEnabled,
      textInputAction: widget.textInputAction,
      autofillHints: widget.isEnabled ? widget.autofillHints : null,
      textCapitalization: widget.cap,
      keyboardType: widget.type,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: widget.cursorColor,
      autofocus: widget.autofocus,
      showCursor: widget.showCursor,
      validator: widget.validator as String? Function(String?)?,
      controller: widget.controller ?? controller,
      toolbarOptions: widget.toolbarOptions,
      style: widget.style ??
          TextStyle(
            fontSize: widget.textSize,
            color: widget.textColor ?? textColor,
          ),
      inputFormatters: widget.digitsOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : widget.inputFormatters,
      decoration: widget.inputDecoration ??
          returnTextFieldInputDecoration(
            context,
            hint: widget.hint,
            check: widget.check,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            lineVisible: widget.lineVisible,
            padding: widget.tfPadding,
            showCounter: widget.showCounter,
          ),
      onChanged: widget.onChanged,
      onFieldSubmitted: (value) {
        widget.onSubmitted?.call(value);
      },
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      onTap: widget.onTap,
    );
  }

  InputDecoration returnTextFieldInputDecoration(
    BuildContext context, {
    bool? check,
    String? hint,
    EdgeInsets padding = const EdgeInsets.only(right: 30, top: 8, bottom: 16),
    bool lightOnly = false,
    bool lineVisible = true,
    bool showCounter = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      contentPadding: padding,
      isDense: true,
      suffixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 23),
      suffixIcon: widget.showClear ? returnClearIcon() : suffixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 23),
      prefixIcon: prefixIcon,
      hintText: hint,
      disabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
    );
  }

  Widget returnClearIcon() {
    final textController = widget.controller ?? controller;

    return SizedBox(
      height: 30,
      width: 30,
      child: textController.text.isNotEmpty
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                textController.clear();
                widget.onChanged!('');
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 3, top: 4, right: 4),
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            )
          : null,
    );
  }
}
