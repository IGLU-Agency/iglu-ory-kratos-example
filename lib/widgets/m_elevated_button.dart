/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

import 'package:iglu_ory_kratos_example/importer.dart';

class MElevatedButton extends StatelessWidget {
  const MElevatedButton({
    this.title,
    this.backgroundColor,
    this.onPressed,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.height,
    this.width,
    this.textSize,
    this.elevation,
    this.image,
    this.borderWidth,
    this.iconSize,
    this.padding = const EdgeInsets.only(
      top: 2,
      left: 24,
      right: 24,
    ),
    this.elevationState,
    this.paddingState,
    this.backgroundColorState,
    this.sideState,
    this.isLoading = false,
    this.highlightColor,
    this.disabledColor,
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.textStyle,
    this.reduce = false,
  }) : super(key: key);

  final String? title;
  final Color? backgroundColor;
  final Color? textColor;
  final Function()? onPressed;
  final Color? borderColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final double? textSize;
  final String? image;
  final double? elevation;
  final EdgeInsets padding;
  final bool isLoading;
  final Color? highlightColor;
  final Color? disabledColor;
  final double? borderWidth;
  final double? iconSize;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? textStyle;
  final bool reduce;

  final MaterialStateProperty<double>? elevationState;
  final MaterialStateProperty<Color>? backgroundColorState;
  final MaterialStateProperty<EdgeInsets>? paddingState;
  final MaterialStateProperty<BorderSide>? sideState;

  double get _loadingSize {
    return (height ?? 54) - 22;
  }

  @override
  Widget build(BuildContext context) {
    Color? getColor(Set<MaterialState> states) {
      const interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.focused,
      };

      const hoveredStates = <MaterialState>{
        MaterialState.hovered,
      };

      const disabledStates = <MaterialState>{
        MaterialState.disabled,
        MaterialState.error,
      };

      if (states.any(interactiveStates.contains)) {
        return primaryColor.withOpacity(0.7);
      } else if (states.any(disabledStates.contains)) {
        return Colors.grey.shade400;
      } else if (states.any(hoveredStates.contains)) {
        return primaryColor.withOpacity(0.85);
      }
      return primaryColor;
    }

    return Stack(
      children: [
        Container(
          height: height ?? 50,
          width: width,
          constraints: const BoxConstraints(maxHeight: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              animationDuration: const Duration(milliseconds: 400),
              elevation: elevationState ?? MaterialStateProperty.all(0),
              backgroundColor: backgroundColorState ??
                  MaterialStateProperty.resolveWith(getColor),
              padding: paddingState ??
                  MaterialStateProperty.all<EdgeInsets>(padding),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black12),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: reduce ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (image != null && isLoading == false)
                  Image.asset(
                    image!,
                    fit: BoxFit.contain,
                  ),
                if (title != null && (image != null)) const SizedBox(width: 6),
                if (isLoading == false && title != null)
                  Text(
                    title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Align(
              child: SizedBox(
                height: _loadingSize,
                width: _loadingSize,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(textColor),
                ),
              ),
            ),
          )
      ],
    );
  }
}
