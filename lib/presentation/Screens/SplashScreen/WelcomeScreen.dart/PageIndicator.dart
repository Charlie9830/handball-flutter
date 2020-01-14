import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int pageQty;
  final int currentPageIndex;
  
  const PageIndicator({Key key, this.pageQty, this.currentPageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getChildren(),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> indicators = [];
    final int _currentPageIndex = currentPageIndex ?? 0;
    
    for (int i = 0; i < pageQty; i++) {
      indicators.add(_buildIndicator(i == _currentPageIndex));
    }

    return indicators;
  }

  Widget _buildIndicator(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: isActive ? 32 : 16,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white38,
          borderRadius: BorderRadius.circular(4)
        ),
      ),
    );
  }
}