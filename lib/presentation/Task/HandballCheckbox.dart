import 'package:flutter/material.dart';
import 'package:handball_flutter/configValues.dart';

const double _checkedRadius = 1;
const double _unCheckedRadius = 0;

const double height = 20;
const double width = 20;

const double padding = 24;

class HandballCheckbox extends StatefulWidget {
  final bool checked;
  final dynamic onChanged;

  HandballCheckbox({
    @required this.checked,
    @required this.onChanged,
  });

  @override
  _HandballCheckboxState createState() => _HandballCheckboxState();
}

class _HandballCheckboxState extends State<HandballCheckbox>
    with TickerProviderStateMixin {
  AnimationController _backgroundAnimationController;
  AnimationController _checkAnimiationController;
  Tween<double> _backgroundTween;
  Tween<double> _checkTween;
  bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked;

    _backgroundAnimationController = AnimationController(
        duration: taskCheckboxAnimationDuration,
        vsync: this,
        value: widget.checked ? _checkedRadius : _unCheckedRadius,
        upperBound: _checkedRadius,
        lowerBound: _unCheckedRadius);

    _backgroundTween = Tween<double>(begin: 1, end: 0);

    _checkAnimiationController = AnimationController(
        duration: taskCheckboxAnimationDuration,
        vsync: this,
        value: widget.checked ? 1.0 : 0.0,
        upperBound: 1.0,
        lowerBound: 0.0);

    _checkTween = Tween<double>(begin: 0, end: 1);
  }

  @override
  void didUpdateWidget(HandballCheckbox oldWidget) {
    if (oldWidget.checked != widget.checked) {
      _isChecked = widget.checked;

      if (widget.checked) {
        _driveToChecked();
      } else {
        _driveToUnchecked();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final unCheckedBackgroundColor = Colors.transparent;
    final checkedBackgrounColor = Theme.of(context).accentColor;

    final backgroundAnimation = _backgroundTween.animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Interval(0, 0.6, curve: Curves.easeInOutCubic),
    ));

    final checkAnimation = _checkTween.animate(CurvedAnimation(
        parent: _checkAnimiationController,
        curve: Interval(0.4, 1, curve: Curves.bounceIn)));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Container(
        height: height + padding,
        width: width + padding,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: backgroundAnimation,
          builder: (context, _widget) {
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).unselectedWidgetColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  gradient: RadialGradient(
                    colors: <Color>[
                      unCheckedBackgroundColor,
                      checkedBackgrounColor
                    ],
                    stops: <double>[1.0, 1.0],
                    radius: backgroundAnimation.value,
                  )),
              child: ScaleTransition(
                  scale: checkAnimation, child: Icon(Icons.check, size: 16)),
            );
          },
        ),
      ),
    );
  }

  void _handleTap() async {
    final newValue = !_isChecked;
    setState(() {
      _isChecked = newValue;
    });

    if (newValue == true) {
      _driveToChecked();
    } else {
      _driveToUnchecked();
    }

    // Pause to allow the Animation to run its course.
    // We also animated a Task being uncompleted. But this only possible if the user has elected to 'Show Compelted Tasks'.
    // If we paused for effect on an uncompelting task it blinks into the wrong state for a few moments.
    if (newValue == true) {
      await Future.delayed(taskCheckboxAnimationDuration);
    }

    widget.onChanged(newValue);
  }

  void _driveToChecked() {
    _backgroundAnimationController.forward();
    _checkAnimiationController.forward();
  }

  void _driveToUnchecked() {
    _backgroundAnimationController.reverse();
    _checkAnimiationController.reverse();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _checkAnimiationController.dispose();
    super.dispose();
  }
}
