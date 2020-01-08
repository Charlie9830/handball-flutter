import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
