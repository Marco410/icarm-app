import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(color: Colors.black54),
    );
  }
}
