import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;
  final bool showBottom;
  final Widget bottom;
  final Widget leading;

  final _prefferedSize = 72.0;

  const HomeScreenAppBar(
      {Key key,
      this.title,
      this.actions,
      this.showBottom = false,
      this.bottom,
      this.leading,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _backgroundColor =
        this.backgroundColor ?? Theme.of(context).primaryColor;
    final bgColorLuminance = _backgroundColor.computeLuminance();
    final iconTheme = bgColorLuminance > 0.5
        ? Theme.of(context).primaryIconTheme.copyWith(color: Colors.black)
       : Theme.of(context).primaryIconTheme.copyWith(color: Colors.white);
    
    final textStyle = bgColorLuminance > 0.5 ? Theme.of(context).primaryTextTheme.title.copyWith(
      color: Colors.black,
      fontFamily: 'Ubuntu'
    ) : Theme.of(context).primaryTextTheme.title.copyWith(
      color: Colors.white,
      fontFamily: 'Ubuntu'
    );

    return IconTheme(
      data: iconTheme,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: Duration(milliseconds: 150),
            bottom: showBottom == true ? 0 : 24,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: bottom,
              height: 24,
            ),
          ),
          ClipPath(
            clipper: _AppBarClipper(),
            child: Material(
              color: _backgroundColor,
              elevation: 4.0,
              child: SafeArea(
                top: true,
                child: Container(
                    height: _prefferedSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Main AppBar Contents
                        Container(
                          child: Row(
                            children: <Widget>[
                              leading ??
                                  IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                  ),
                              Expanded(
                                child: Text(title ?? '',
                                    style: textStyle,
                                    overflow: TextOverflow.ellipsis,),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: actions,
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefferedSize);
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
        size.width - 4, size.height - 24, size.width - 20, size.height - 24);
    path.lineTo(20, size.height - 24);
    path.quadraticBezierTo(4, size.height - 24, 0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
