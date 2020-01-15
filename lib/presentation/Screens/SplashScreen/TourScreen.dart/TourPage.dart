import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/styleMixins.dart';

class TourPage extends StatelessWidget {
  final Image image;
  final String headline;
  final String detail;

  const TourPage({Key key, this.image, this.headline, this.detail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headlineMixin =  getHeadlineTextStyleMixin(Theme.of(context).brightness);
    final detailMixin = getDetailTextStyleMixin(Theme.of(context).brightness);

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Expanded(child: image),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(headline ?? '',
                  style: Theme.of(context).textTheme.headline.copyWith(
                        color: headlineMixin.color,
                        fontFamily: headlineMixin.fontFamily,
                        fontSize: headlineMixin.fontSize,
                        fontWeight: headlineMixin.fontWeight,
                      ))),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(detail ?? '',
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: detailMixin.color,
                      fontFamily: detailMixin.fontFamily,
                      fontSize: detailMixin.fontSize,
                      fontWeight: detailMixin.fontWeight,
                    )),
          ),
        ],
      ),
    );
  }
}
