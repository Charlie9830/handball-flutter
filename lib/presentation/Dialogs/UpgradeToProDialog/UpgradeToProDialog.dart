import 'package:flutter/material.dart';
import 'package:handball_flutter/models/UpgradeToProViewDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/UpgradeToProDialog/NoStoreFallback.dart';
import 'package:handball_flutter/presentation/Dialogs/UpgradeToProDialog/StoreLoading.dart';
import 'package:handball_flutter/presentation/Dialogs/UpgradeToProDialog/StoreShelf.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UpgradeToProDialog extends StatefulWidget {
  final UpgradeToProDialogViewModel viewModel;

  UpgradeToProDialog({Key key, @required this.viewModel}) : super(key: key);

  _UpgradeToProDialogState createState() => _UpgradeToProDialogState();
}

class _UpgradeToProDialogState extends State<UpgradeToProDialog> {
  bool isLoading = true;
  bool isStoreAvailable = true;
  ProductDetails product;

  @override
  void initState() {
    super.initState();
    _connectAndRetrieveProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade to Pro'),
      ),
      body: Container(
        child: _getContent(),
      ),
    );
  }

  Widget _getContent() {
    if (isLoading) {
      return StoreLoading();
    }

    if (isStoreAvailable == false) {
      return NoStoreFallback();
    } else {
      return StoreShelf(
        onPurchase: _handlePurchase,
        product: product
      );
    }
  }

  void _handlePurchase() async {
    PurchaseParam purchaseParam = PurchaseParam(productDetails: product, applicationUserName: widget.viewModel.userId);

    InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _connectAndRetrieveProducts() async {
    var available = await InAppPurchaseConnection.instance.isAvailable();
    if (available == false) {
      setState(() {
        isStoreAvailable = false;
        isLoading = false;
      });
    }

    Set<String> productIds = <String>['test.subscription'].toSet();
    var response =
        await InAppPurchaseConnection.instance.queryProductDetails(productIds);

    if (response.notFoundIDs.length == response.productDetails.length) {
      // Products could not be loaded. (We only offer 1 product)
      setState(() {
        isStoreAvailable = false;
        isLoading = false;
      });
    } else {
      setState(() {
        product = response.productDetails.first;
        isLoading = false;
        isStoreAvailable = true;
      });
    }
  }
}
