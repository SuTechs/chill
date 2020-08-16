import 'package:flutter/material.dart';

enum MaxSizeSide { Right, Left }

class CustomDividedScreen extends StatelessWidget {
  final Widget maxSideChild;
  final Widget minSideChild;
  final MaxSizeSide maxSizeSide;

  const CustomDividedScreen({
    Key key,
    @required this.maxSideChild,
    @required this.minSideChild,
    this.maxSizeSide = MaxSizeSide.Right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// right
        Expanded(
          flex: maxSizeSide == MaxSizeSide.Right ? 5 : 1,
          child: maxSizeSide == MaxSizeSide.Right ? maxSideChild : minSideChild,
        ),
        Container(
          width: 0.5,
          color: Colors.red,
        ),

        /// left
        Expanded(
          flex: maxSizeSide == MaxSizeSide.Left ? 5 : 1,
          child: maxSizeSide == MaxSizeSide.Left ? maxSideChild : minSideChild,
        ),
      ],
    );
  }
}
