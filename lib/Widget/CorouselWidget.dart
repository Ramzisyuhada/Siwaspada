import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Corouselwidget extends StatefulWidget {
  final List<String> dataGambar;

  const Corouselwidget({
    super.key,
    required this.dataGambar,
  });

  @override
  State<Corouselwidget> createState() => _CorouselwidgetState();
}

class _CorouselwidgetState extends State<Corouselwidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.dataGambar.map((img) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            img,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }
}
