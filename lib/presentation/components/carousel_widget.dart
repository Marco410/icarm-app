import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget(
      {super.key,
      required this.image,
      required this.textItems,
      required this.controller,
      required this.current,
      required this.mainColor,
      required this.size,
      required this.onPageChanged});

  final List<Widget> textItems;
  final CarouselController controller;
  final int current;
  final Function onPageChanged;
  final String image;
  final Color mainColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: textItems.length,
          carouselController: controller,
          options: CarouselOptions(
              autoPlay: true,
              initialPage: current,
              enlargeCenterPage: true,
              height: size,
              animateToClosest: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: onPageChanged as void Function(
                  int, CarouselPageChangedReason)?),
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: textItems[itemIndex],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: textItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                controller.animateToPage(entry.key.toInt(),
                    duration: const Duration(milliseconds: 500));
              },
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: (mainColor)
                        .withOpacity(current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
