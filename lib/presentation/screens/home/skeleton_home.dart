import 'package:flutter/Material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../config/setting/style.dart';

class SkeletonHome extends StatefulWidget {
  const SkeletonHome({super.key});

  @override
  State<SkeletonHome> createState() => _SkeletonHomeState();
}

class _SkeletonHomeState extends State<SkeletonHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Skeleton(
            heigh: 40.h,
            width: double.infinity,
          ),
          Row(
            children: [
              Expanded(
                child: Skeleton(
                  heigh: 4.h,
                  width: double.infinity,
                ),
              ),
              Expanded(
                child: Skeleton(
                  heigh: 4.h,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Skeleton(
                  heigh: 10.h,
                  width: double.infinity,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Skeleton(
                      heigh: 3.h,
                      width: double.infinity,
                    ),
                    Skeleton(
                      heigh: 3.h,
                      width: double.infinity,
                    ),
                    Skeleton(
                      heigh: 3.h,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Skeleton(
            heigh: 4.h,
            width: double.infinity,
          ),
          Skeleton(
            heigh: 4.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  final double heigh;
  final double width;
  const Skeleton({super.key, required this.heigh, required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Shimmer.fromColors(
        baseColor: ColorStyle.hintLightColor,
        highlightColor: Colors.white,
        child: Container(
          width: width,
          height: heigh,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.grey),
        ),
      ),
    );
  }
}
