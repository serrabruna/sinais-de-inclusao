import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

class CarouselImages extends StatefulWidget {
  const CarouselImages({super.key});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  final List<List<String>> imageGroups = [
    [
      'assets/images/Sinal1.jpg',
      'assets/images/Sinal2.jpg',
    ],
    [
      'assets/images/Sinal3.jpg',
      'assets/images/Sinal4.jpg',
    ],
    [
      'assets/images/Sinal5.jpg',
      'assets/images/Sinal6.jpg',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return carousel_slider.CarouselSlider(
      options: carousel_slider.CarouselOptions(
        height: 300.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16/9,
        initialPage: 0,
      ),
      items: imageGroups.map((group) {
        return Builder(
          builder: (BuildContext context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: group.map((imagePath) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      imagePath, 
                      fit: BoxFit.cover,
                      height: 200,
                      width: 150
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      }).toList(),
    );
  }
}