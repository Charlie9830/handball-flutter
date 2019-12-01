import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StoreShelf extends StatelessWidget {
  final ProductDetails product;
  final dynamic onPurchase;

  const StoreShelf({Key key, this.product, this.onPurchase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swiper(
          itemCount: 4,
          autoplay: false,
          loop: false,
          itemBuilder: (context, index) {
            return _getSlide(index);
          },
          pagination: new SwiperPagination(

          ),
        );
  }

  Widget _getSlide(int index) {
    switch(index) {
      case 0:
      return Text("It's Good");
      case 1:
      return Text("Like Really Good");
      case 2:
      return Text("It will blow your socks off");
      case 3:
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('${product.price} per month'),
            RaisedButton(
              child: Text("Upgrade"),
              onPressed: onPurchase,
            ),
        ],
      );
      default :
      return Text("Bought it yet?");
    }
  }
}
