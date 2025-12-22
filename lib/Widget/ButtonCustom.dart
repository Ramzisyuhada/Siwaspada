import 'package:flutter/material.dart';

class Buttoncustom extends StatefulWidget {
  final String textButton;
  final Color datacolor;
  final VoidCallback onPressed; // 👈 CALLBACK
  final double ValueRadius;
  final Color dataColorText;
  const Buttoncustom({
    super.key,
    required this.textButton,
    required this.datacolor,
    required this.onPressed,
    required this.ValueRadius,
    required this.dataColorText
  });

  @override
  State<Buttoncustom> createState() => _ButtoncustomState();
}

class _ButtoncustomState extends State<Buttoncustom> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white.withOpacity(0.25),
            highlightColor: Colors.blue.withOpacity(0.1),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: widget.onPressed, // 👈 PANGGIL DARI PARENT
            child: Container(
              width: 351,
              height: 46,
              decoration: BoxDecoration(
                color: widget.datacolor,
                borderRadius: BorderRadius.circular(widget.ValueRadius),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.textButton,
                style:  TextStyle(
                  color: widget.dataColorText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
