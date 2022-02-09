import 'dart:async';
import 'dart:io';

// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/show_error.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';
import 'package:notary/views/start.dart';
import 'package:notary/widgets/payment_success.dart';

class AppPurchaseController extends GetxController {
  UserController _userController = Get.put(UserController());
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  RxBool _pending = RxBool(false);

  RxList<ProductDetails> _products = RxList<ProductDetails>([]);

  final List<String> _productIds = Platform.isAndroid
      ? ['basic.ronary.com', 'business.ronary.com', 'pro.ronary.com']
      : ['basic.ronary.com', 'business.ronary.com', 'pro.ronary.com'];

  RxList<ProductDetails> get products => _products;

  @override
  void onInit() async {
    print("PurchaseController => init()");
    //  await FlutterInappPurchase.instance.initialize();
    await initConnection();
    await initStoreInfo();
    super.onInit();
  }

  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  initConnection() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("onError: $error");
    });
  }

  Future<void> initStoreInfo() async {
    print("initStoreInfo() => Executed!");
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();

      if (!isAvailable) {
        _products.value = [];
      }

      if (Platform.isIOS) {
        var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
      }

      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(_productIds.toSet());

      // List<PurchasedItem> purchaseHistory =
      //     await FlutterInappPurchase.instance.getPurchaseHistory();
      // print(purchaseHistory);

      _products.value = productDetailResponse.productDetails;

      update();
    } catch (err) {
      print("Error _initStoreInfo(): $err");
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    print("purchaseDetailsList.length ${purchaseDetailsList.length}");
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Is pending");
        _pending.value = true;
        update();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          showError("Is error");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          await _verifyPurchase(purchaseDetails);
        }
        if (Platform.isAndroid) {
          // if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
          //   final InAppPurchaseAndroidPlatformAddition androidAddition =
          //       _inAppPurchase.getPlatformAddition<
          //           InAppPurchaseAndroidPlatformAddition>();
          //   await androidAddition.consumePurchase(purchaseDetails);
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print("Purchase Completed! ${purchaseDetails.status}");
          await _inAppPurchase.completePurchase(purchaseDetails);
          _pending.value = false;
          update();
        }
      }
    });
  }

  RxBool get pending => _pending;

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.purchaseID != null) {
      try {
        dio.Response resDio = await makeRequest(
          'payment/purchase',
          'POST',
          {
            "transactionReceipt":
                purchaseDetails.verificationData.serverVerificationData,
            "transactionId": purchaseDetails.purchaseID,
          },
        );
        var extracted = resDio.data;
        if (!extracted['success']) {
          throw extracted['message'];
        }
        update();

        Get.offAll(() => PaymentSuccess(), transition: Transition.noTransition);
      } catch (err) {
        print(err);
        throw err;
      }
    }
  }

  Future<void> buyProduct(ProductDetails productDetails, String userId) async {
    try {
      PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: userId,
      );
      var transactions = await SKPaymentQueueWrapper().transactions();
      await Future.wait(transactions.map((transaction) =>
          SKPaymentQueueWrapper().finishTransaction(transaction)));
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (err) {
      throw err;
    }
  }


}

class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
