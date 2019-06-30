import 'package:flutter/material.dart';

class ColorChit extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final dynamic onPressed;
  const ColorChit({Key key, this.color, this.isSelected, this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(isSelected == true ? 0 : 16),
        width: isSelected == true ? 32 : 16,
        height: isSelected == true ? 32 : 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
