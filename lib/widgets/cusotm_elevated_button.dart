import 'package:flutter/material.dart';

class Customelevatedbutton extends StatelessWidget {
  const Customelevatedbutton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.backGroundColor,
    this.forGroundColor,
    this.image,
    this.borderColor,
  });

  final String buttonText;
  final void Function()? onPressed;
  final WidgetStateProperty<Color?>? backGroundColor;
  final WidgetStateProperty<Color?>? forGroundColor;
  final String? image;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(color: borderColor ?? Colors.grey),
        ),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: backGroundColor,
        foregroundColor:
            forGroundColor ?? WidgetStatePropertyAll(Colors.blueGrey),
        textStyle: WidgetStatePropertyAll(
          textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 10),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
      onPressed: onPressed,
      child: image == null
          ? Text(buttonText)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image!, width: 24, height: 24),
                const SizedBox(width: 10),
                Text(buttonText),
              ],
            ),
    );
  }
}
