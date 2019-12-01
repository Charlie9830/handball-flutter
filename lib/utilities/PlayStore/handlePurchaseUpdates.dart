import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:redux/redux.dart';

void handlePurchaseUpdates(
    List<PurchaseDetails> purchases, Store<AppState> store) async {
  var purchase = purchases.last;

  if (purchase.status == PurchaseStatus.purchased) {
    var ref = Firestore.instance
        .collection('users')
        .document(store.state.user.userId);

    try {
      await ref.updateData({
        'isPro': true,
        'playPurchaseId': purchase.purchaseID,
        'playPurchaseDate': purchase.transactionDate,
        'playProductId': purchase.productID,
      });

      // TODO: Notify the user that they have sucessfully upgraded. Or Handle an error if this fails to complete.
    } catch (error) {
      throw error;
    }
  }
}