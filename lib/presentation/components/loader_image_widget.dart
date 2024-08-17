import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:shimmer/shimmer.dart';

class LoaderImageWidget extends StatelessWidget {
  const LoaderImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey.withOpacity(0.2),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.grey,
          ),
        ),
        Icon(
          Icons.image_rounded,
          color: ColorStyle.whiteBacground,
        )
      ],
    );
  }
}
