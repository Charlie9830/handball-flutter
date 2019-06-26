import 'package:flutter/material.dart';

class SelectCheckbox extends StatefulWidget {
  final bool value;
  final dynamic onChanged;

  SelectCheckbox({this.value, this.onChanged});

  @override
  _SelectCheckboxState createState() => _SelectCheckboxState();
}

class _SelectCheckboxState extends State<SelectCheckbox>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
          margin: EdgeInsets.all(8),
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2,
              )),
          child: AnimatedSize(
            duration: Duration(milliseconds: 250),
            alignment: Alignment.center,
            vsync: this,
            child: Icon(Icons.check, size: widget.value == true ? 16 : 0),
          )),
    );
  }
}
