import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/ads_provider.dart';

class CarouselWidget extends ConsumerStatefulWidget {
  const CarouselWidget(
      {super.key,
      required this.image,
      required this.controller,
      required this.current,
      required this.mainColor,
      required this.size,
      required this.onPageChanged});

  final CarouselSliderController controller;
  final int current;
  final Function onPageChanged;
  final String image;
  final Color mainColor;
  final double size;

  @override
  ConsumerState<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends ConsumerState<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adsHomeProvider);
    return ads.when(
      data: (data) {
        if (data.isEmpty) {
          return SizedBox();
        }
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: data.length,
              carouselController: widget.controller,
              options: CarouselOptions(
                  autoPlay: true,
                  pauseAutoPlayOnTouch: true,
                  initialPage: widget.current,
                  enlargeCenterPage: true,
                  height: widget.size,
                  animateToClosest: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: widget.onPageChanged as void Function(
                      int, CarouselPageChangedReason)?),
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: data[itemIndex],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    widget.controller.animateToPage(entry.key.toInt(),
                        duration: const Duration(milliseconds: 500));
                  },
                  child: Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: (widget.mainColor).withOpacity(
                            widget.current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
      error: (error, stackTrace) => SizedBox(),
      loading: () => Center(
        child: LoadingStandardWidget.loadingWidget(),
      ),
    );
  }
}
