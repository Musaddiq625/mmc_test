import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final String btnText;
  final Function()? onBtnPressed;
  final Color? btnColor;

  const UIButton(
    this.btnText, {
    super.key,
    this.onBtnPressed,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    const double defaultBorderRadius = 8;
    final w = MediaQuery.of(context).size.width;
    BorderRadius radius() => BorderRadius.circular(defaultBorderRadius);
    return InkWell(
      onTap: onBtnPressed,
      splashColor: Colors.red,
      borderRadius: radius(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              color:
                  onBtnPressed == null ? Colors.grey.withOpacity(.5) : btnColor ?? Colors.blue,
            ),
            alignment: Alignment.center,
            child: Text(
              btnText,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onBtnPressed == null
                    ? Colors.black.withOpacity(.5)
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
