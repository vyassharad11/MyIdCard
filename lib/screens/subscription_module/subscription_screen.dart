
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import 'package:my_di_card/models/subscription_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/team/create_team.dart';
import 'package:provider/provider.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../notifire_class.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../home_module/first_card.dart';
import 'package:http/http.dart' as http;

class SubscriptionScreen extends StatefulWidget {
  final  bool? isFromCreateProfile;
  int?planId;
  SubscriptionScreen({super.key,this.isFromCreateProfile = false,this.planId});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int planId = 1;
  AuthCubit? _setPlanCubit,planCubit,_subscribePlan,_freePlanCubit;
  List<SubscriptionDatum> planList = [];
  List<SubscriptionDatum> monthlyPlanList = [];
  List<SubscriptionDatum> yearlyPlanList = [];
  InAppPurchase? _iap;
  List<ProductDetails> _products = [];
  late StreamSubscription _subscription;
  ProductDetails? pro;
  PurchaseDetails? _purchaseDetails;
  bool isRequestToPurchase = false;
  var _purchaseId = "";
  String price = "";
  String planType = "";
  String monthlyPriceIndividual = "";
  String monthlyPriceTeam = "";
  String yearlyPriceIndividual = "";
  String yearlyPriceTeam = "";
  String symbolForAllCounty = "";
  String subscriptionPlanID = "";


  Future<void> submitPlanId(_purchaseId) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "plan_id": planId.toString()
    };
    _setPlanCubit?.apiSetPlan(data);
  }

  Future<void> freePlanSetApi() async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "plan_id": "1"
    };
    _freePlanCubit?.apiSetPlan(data);
  }

  Future<void> apisSubscribePlan() async {
    Utility.showLoader(context);
    DateTime today = DateTime.now();
    DateTime oneMonthLater = addMonths(today, 1);
    DateTime oneYearLater = addYears(today, 1);
    Map<String, dynamic> data = {
      "plan_id": planId.toString(),
      "transaction_id": _purchaseId,
      "status":"done",
      "amount":price,
      "coupon_id":"",
      "start_date":today.toString(),
      "end_date": planType == "monthly"?oneMonthLater.toString():oneYearLater.toString()

    };
    _subscribePlan?.apisSubscribePlan(data);
  }

  DateTime addMonths(DateTime date, int monthsToAdd) {
    int newYear = date.year;
    int newMonth = date.month + monthsToAdd;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    int day = date.day;
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (day > lastDayOfNewMonth) {
      day = lastDayOfNewMonth;
    }

    return DateTime(newYear, newMonth, day, date.hour, date.minute, date.second);
  }

  DateTime addYears(DateTime date, int yearsToAdd) {
    int newYear = date.year + yearsToAdd;
    int newMonth = date.month;

    int day = date.day;
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (day > lastDayOfNewMonth) {
      day = lastDayOfNewMonth;
    }

    return DateTime(newYear, newMonth, day, date.hour, date.minute, date.second);
  }


  @override
  void initState() {
    planId == widget.planId ?? 0;
    _setPlanCubit = AuthCubit(AuthRepository());
    _freePlanCubit = AuthCubit(AuthRepository());
    _subscribePlan = AuthCubit(AuthRepository());
    planCubit = AuthCubit(AuthRepository());
    planCubit?.apiGetPlan();
    _initPurchaseStore();
    super.initState();
  }


  @override
  void dispose() {
    _setPlanCubit?.close();
    _subscribePlan?.close();
    _freePlanCubit?.close();
    planCubit?.close();
    _freePlanCubit = null;
    _subscribePlan = null;
    _setPlanCubit = null;
    planCubit = null;
    // TODO: implement dispose
    super.dispose();
  }
  bool isLoad = true;

  Future<void> _initPurchaseStore() async {
    // Check availability of InApp Purchases
    _iap = InAppPurchase.instance;
    bool? isAvailable = await _iap?.isAvailable();
    if (!isAvailable!) {
      print("===IAP is Available: $isAvailable");
      return;
    }

    _subscription = _iap!.purchaseStream.listen(
            (List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
      print("===IAP onError: ${error}");
    });

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _iap!.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async
  {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
        // Handle pending state
          debugPrint("===IAP Status:Pending");
          break;

        case PurchaseStatus.error:
          debugPrint("===IAP Status:Error: ${purchaseDetails.error}");
          setState(() {
            isRequestToPurchase = false;
          });
          Utility().showFlushBar(
              context: context,
              message: purchaseDetails.error.toString(),
              isError: true);
          break;

        case PurchaseStatus.purchased:
          if (kDebugMode) {
            print("AR purchased storeproduct ====  222222 ${_products}");
          }
          setState(() {
            isRequestToPurchase = false;
          });
          _purchaseDetails = purchaseDetails;
          if (kDebugMode) {
            print("AR  purchased _purchaseDetails ====  222222 ${_purchaseDetails}");
          }
          _purchaseId = _purchaseDetails?.purchaseID ?? "";
          if (kDebugMode) {
            print("AR  purchased _purchaseId ====  222222 ${_purchaseId}");
          }
          var productID = _purchaseDetails?.productID ?? "";
          print("AR  purchased productID ====  222222 ${productID}");
          submitPlanId(_purchaseId);
          break;
        case PurchaseStatus.restored:
          setState(() {
            isRequestToPurchase = false;
          });
          _purchaseDetails = purchaseDetails;
          _purchaseId = _purchaseDetails?.purchaseID ?? "";
          submitPlanId(_purchaseId);
          break;

        case PurchaseStatus.canceled:
          setState(() {
            isRequestToPurchase = false;
          });
          debugPrint("===IAP Status:Canceled");
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap?.completePurchase(purchaseDetails);
      }
    }
  }
  ProductDetails _getProductDetails(String productId) {
    print(">>> Entered _getProductDetails for $productId");
    for (var p in _products) {
      print("Available product: ${p.id}");
    }
    final matched = _products.where((element) => element.id == productId).toList();

    if (matched.isEmpty) {
      print("⚠️ No product found for ID: $productId. Products list: $_products");
      // return null;
    }

    final proDetails = matched.first;
    print("PLAN ID ==> $proDetails   <><><>$productId    SUBPLANID ==> $subscriptionPlanID");

    return proDetails;
  }


  // Method to retrieve product list

  // Future<void> _getIAPStoreProductsDetail(Set<String> productIds) async {
  //   ProductDetailsResponse response =
  //   await _iap!.queryProductDetails(productIds);
  //   setState(() {
  //     _products.addAll(response.productDetails);
  //   });
  // }
  Future<void> _getIAPStoreProductsDetail(Set<String> productIds) async {
    print("freee>>>>>>>>>>>>>$productIds");
    ProductDetailsResponse response =
    await _iap!.queryProductDetails(productIds);
    setState(() {
      print("response.productDetails${response.productDetails}>>${response.productDetails.length}");
      _products.addAll(response.productDetails);
      for (var e in response.productDetails) {
        symbolForAllCounty = e.currencySymbol ?? "";
        print("storeproduct ====  11111ssss ${e.id}");
        print("storeproduct ====  11111 ${e.currencySymbol}");
        print("storeproduct ====  11111 ${e.price}");
        if(e.id == "com.mydicard.mydicard.individual") {
          monthlyPriceIndividual = e.price ?? "";
        }else if(e.id == "com.mydicard.mydicard.individual.annual") {
          yearlyPriceIndividual = e.price ?? "";
        }else if(e.id == "com.mydicard.mydicard.team") {
          monthlyPriceTeam = e.price ?? "";
        }else if(e.id == "com.mydicard.mydicard.team.annual"){
          yearlyPriceTeam = e.price ?? "";
        }

      }
      print("storeproduct ====  11111 ${_products}");

    });
  }

  // Method to purchase a product
  void _buyProduct(ProductDetails prod) {
    print("_buyProduct Methode ==> $prod");
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap?.buyNonConsumable(purchaseParam: purchaseParam);
  }


  //
  // callBuyRechargePointApi(String purchaseId) {
  //   if(mounted){
  //     Utility.showLoader(context);
  //   }
  //   Map<String, dynamic> data = {
  //     "planId": id.toString(),
  //     "chargeId" : purchaseId,
  //     "device_type" : Platform.isAndroid ? "android" : "ios"
  //   };
  //   // print("Data>>>${jsonEncode(data)}");
  //   _buyPointsCubit?.apiUserSubscription(data);
  // }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<AuthCubit, ResponseState>(
        bloc: _freePlanCubit,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          } else if (state is ResponseStateEmpty) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateNoInternet) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateError) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
          } else if (state is ResponseStateSuccess) {
            var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              if(widget.isFromCreateProfile == true) {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
              }else{
                Navigator.pop(context);
              }
              Utility().showFlushBar(context: context, message: dto.message ?? "");
          }
          setState(() {});
        },),
      BlocListener<AuthCubit, ResponseState>(
        bloc: _setPlanCubit,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          } else if (state is ResponseStateEmpty) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateNoInternet) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateError) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
          } else if (state is ResponseStateSuccess) {
            var dto = state.data as UtilityDto;
            if(planId == 1){
              Utility.hideLoader(context);
              if(widget.isFromCreateProfile == true) {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
              }else{
                Navigator.pop(context);
              }
              Utility().showFlushBar(context: context, message: dto.message ?? "");
            }else {
              apisSubscribePlan();
            }
          }
          setState(() {});
        },),
      BlocListener<AuthCubit, ResponseState>(
        bloc: _subscribePlan,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          } else if (state is ResponseStateEmpty) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateNoInternet) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateError) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
          } else if (state is ResponseStateSuccess) {
            Utility.hideLoader(context);
            var dto = state.data as UtilityDto;
            if(widget.isFromCreateProfile == true) {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
            }else{
              Navigator.pop(context);
            }
            Utility().showFlushBar(context: context, message: dto.message ?? "");
          }
          setState(() {});
        },),
      BlocListener<AuthCubit, ResponseState>(
        bloc: planCubit,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          } else if (state is ResponseStateEmpty) {
            isLoad = false;
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateNoInternet) {
            isLoad = false;
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateError) {
            isLoad = false;
            Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
          } else if (state is ResponseStateSuccess) {
            var dto = state.data as SubscriptionModel;
            if(dto != null && dto.data != null && dto.data!.isNotEmpty) {
              planList.addAll(dto.data ?? []);
              planList.forEach((element) {
                print("planType>>>>>${element.type}");
                if(element.id.toString() == "1"){
                  print("plan>>>ssssss>>${element.id}");
                  monthlyPlanList.add(element);
                  yearlyPlanList.add(element);
                }
                if(element?.type == "monthly"){
                  print("plan>>>ddddd>>${element.id}");
                  monthlyPlanList.add(element);
                }else if(element?.type == "yearly"){
                  print("plan>>>yyyyy>>${element.id}");
                  yearlyPlanList.add(element);
                }
              },);
              monthlyPlanList.forEach((element) {
                print("plan>>>nsmer>>${element.planName}");

              },);
              print("length${planList.length}");
              if(Platform.isIOS) {
                Set<String>? proIds = planList
                    ?.map((e) =>
                e.ios.toString() ?? "")
                    .toSet();
                if (proIds != null) {
                  _getIAPStoreProductsDetail(proIds);
                }
              }else{
                Set<String>? proIds = planList
                    ?.map((e) =>
                e.android.toString() ?? "")
                    .toSet();
                if (proIds != null) {
                  _getIAPStoreProductsDetail(proIds);
                }
              }
            }
            isLoad = false;
          }
          setState(() {});
        },),
    ],
      child: Scaffold(
          backgroundColor: ColoursUtils.background.withOpacity(1.0),
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: Colors.black),
            foregroundColor: Colors.white,
            backgroundColor: ColoursUtils.background,
            title: Text(
              AppLocalizations.of(context).translate('upgradeToPremium'),
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          body: isLoad?Center(child: CircularProgressIndicator())
              :planList != null && planList!.isNotEmpty ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          tabAlignment: TabAlignment.fill,
                          labelStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.black,
                          isScrollable: false,
                          indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(text: 'Monthly'),
                            Tab(text: 'Yearly'),
                          ],
                        ),
                      ),
                      Expanded( // ✅ now works correctly
                        child: TabBarView(
                          children: [
                            /// monthly list
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              itemCount: monthlyPlanList.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                return SubscriptionOption(
                                  monthYear: "month",
                                  title: Provider.of<LocalizationNotifier>(context).appLocal == const Locale("en")
                                      ? monthlyPlanList[index].planName ?? ""
                                      : monthlyPlanList[index].frPlanName ?? "",
                                  price: index == 0?  "0${symbolForAllCounty}" :"${index ==1 ?monthlyPriceIndividual.toString():monthlyPriceTeam}${symbolForAllCounty}",
                                  isChecked: planId == monthlyPlanList[index].id,
                                  description: Provider.of<LocalizationNotifier>(context).appLocal == const Locale("en")
                                      ? monthlyPlanList[index].discription ?? ""
                                      : monthlyPlanList[index].frDiscription ?? "",
                                  onTap: () {
                                    setState(() {
                                      price = monthlyPlanList[index].price.toString();
                                      planType = monthlyPlanList[index].type.toString();
                                      planId = monthlyPlanList[index].id ?? 0;
                                      subscriptionPlanID =Platform.isIOS ? monthlyPlanList[index].ios ?? "" :  monthlyPlanList[index].android ?? "";
                                    });
                                  },
                                );
                              },
                            ),

                            /// yearly list
                            ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              itemCount: yearlyPlanList.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                return SubscriptionOption(
                                  monthYear: "year",
                                  title: Provider.of<LocalizationNotifier>(context).appLocal == const Locale("en")
                                      ? yearlyPlanList[index].planName ?? ""
                                      : yearlyPlanList[index].frPlanName ?? "",
                                  price: index == 0?  "0${symbolForAllCounty}" :"${index == 1?yearlyPriceIndividual.toString():yearlyPriceTeam}${symbolForAllCounty}",
                                  isChecked: planId == yearlyPlanList[index].id,
                                  description: Provider.of<LocalizationNotifier>(context).appLocal == const Locale("en")
                                      ? yearlyPlanList[index].discription ?? ""
                                      : yearlyPlanList[index].frDiscription ?? "",
                                  onTap: () {
                                    setState(() {
                                      price = yearlyPlanList[index].price.toString();
                                      planId = yearlyPlanList[index].id ?? 0;
                                      planType = yearlyPlanList[index].type.toString();
                                      subscriptionPlanID =Platform.isIOS ? yearlyPlanList[index].ios ?? "" :  yearlyPlanList[index].android ?? "";
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Button stays fixed below TabBarView
              Padding(
                padding: const EdgeInsets.only(top:16,left: 16.0,right: 16,bottom: 6),
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.planId == planId) {
                      Navigator.pop(context);
                    } else if (planId == 1) {
                      submitPlanId("");
                    } else if (subscriptionPlanID.isNotEmpty) {
                      setState(() {
                        isRequestToPurchase = true;
                      });
                      _buyProduct(_getProductDetails(subscriptionPlanID));
                    } else {
                      Utility().showFlushBar(
                        context: context,
                        message: 'Please select your bundle.',
                        isError: true,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue.withOpacity(0.5),
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('subscribe'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Skip for now logic
                  freePlanSetApi();
                },
                child:  Text(
                  AppLocalizations.of(context).translate('skipForNow'),
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ) :Center(child: Text("No Record Found"),)
      ),
    );
  }

  bool ischecked = false;

}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final String monthYear;
  final String description;
  final String? discount;
  final bool isDiscounted;
  final bool isChecked;
  final VoidCallback onTap;

  const SubscriptionOption({super.key,
    required this.title,
    required this.price,
    required this.monthYear,
    required this.isChecked,
    required this.description,
    this.discount,
    this.isDiscounted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            color:  !isChecked
                ? Colors.white
                : ColoursUtils.tileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // if you need this
              side: BorderSide(
                color: !isChecked
                    ? Colors.white
                    : ColoursUtils.primaryColor,
                width: 2,
              ),
            ),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 22.0, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: Checkbox(
                              checkColor: Colors.white,
                              tristate: true,
                              value:
                              isChecked,
                              activeColor: isChecked
                                  ? ColoursUtils.primaryColor
                                  : Colors.white,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                // setState(() {
                                //   isChecked = value!;
                                // });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 230,
                            child: Text(
                              title,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        price,
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "/${monthYear}",
                        softWrap: true,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Html(data: description),
                ],
              ),
            ),
          ),
          // if (isDiscounted)
          //   Align(
          //     alignment: const Alignment(1, 1),
          //     child: Container(
          //       decoration: BoxDecoration(
          //           color: Colors.blue, borderRadius: BorderRadius.circular(4)),
          //       child: Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          //         child: Text(
          //           discount!,
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 14,
          //             fontWeight: FontWeight.normal,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
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
