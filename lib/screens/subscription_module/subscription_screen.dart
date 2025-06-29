
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import 'package:my_di_card/models/subscription_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/team/create_team.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../home_module/first_card.dart';
import 'package:http/http.dart' as http;

class SubscriptionScreen extends StatefulWidget {
final  bool? isFromCreateProfile;
  const SubscriptionScreen({super.key,this.isFromCreateProfile = false});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int planId = 1;
  AuthCubit? _setPlanCubit,planCubit;
  List<SubscriptionDatum> planList = [];

  Future<void> submitPlanId() async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "plan_id": planId.toString()
    };
    _setPlanCubit?.apiSetPlan(data);
  }

  @override
  void initState() {
    _setPlanCubit = AuthCubit(AuthRepository());
    planCubit = AuthCubit(AuthRepository());
    planCubit?.apiGetPlan();
    super.initState();
  }


  @override
  void dispose() {
    _setPlanCubit?.close();
    planCubit?.close();
    _setPlanCubit = null;
    planCubit = null;
    // TODO: implement dispose
    super.dispose();
  }
  bool isLoad = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(right: 16,left: 16,bottom: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                            return SubscriptionOption(
                              title: planList[index].planName ?? "",
                              price: planList[index].price.toString() ?? "",
                              isChecked: planId == planList[index].id,
                              description: planList[index].discription ?? "",
                              // discount: 'selected',
                              // isDiscounted: false,
                              onTap: () {
                                debugPrint("ontap----");
                                setState(() {
                                  // ischecked = !ischecked;
                                  planId = planList[index].id ?? 0;
                                  setState(() {

                                  });
                                });
                                // Subscription logic for Free Tier
                              },
                            );
                          }, separatorBuilder: (context, index) {
                            return SizedBox(height: 0,);

                          }, itemCount: planList.length ?? 0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Subscription action
                          submitPlanId();
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
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // TextButton(
                    //   onPressed: () {
                    //     // Skip for now logic
                    //     submitPlanId();
                    //   },
                    //   child:  Text(
                    //     AppLocalizations.of(context).translate('skipForNow'),
                    //     style: TextStyle(color: Colors.black87),
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                  ],
                ),
              ):Center(child: Text("No Record Found"),)

          // DefaultTabController(
          //   length: 2, // Two tabs: Login and Sign Up
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // Tab bar with "Login" and "Sign Up"
          //
          //       Container(
          //         margin: const EdgeInsets.all(16),
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           border:
          //               Border.all(color: Colors.grey.withOpacity(0.3), width: 3),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         child: TabBar(
          //           tabAlignment: TabAlignment.fill,
          //           labelStyle: const TextStyle(
          //               color: Colors.black, fontWeight: FontWeight.w500),
          //           automaticIndicatorColorAdjustment: true,
          //           labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          //           unselectedLabelColor: Colors.black,
          //           isScrollable: false,
          //           indicatorPadding:
          //               const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          //           indicator: BoxDecoration(
          //             borderRadius: BorderRadius.circular(12),
          //             color: Colors.white,
          //           ),
          //           indicatorSize: TabBarIndicatorSize.tab,
          //           tabs: const [
          //             Tab(text: 'Monthly'),
          //             Tab(text: 'Yearly'),
          //           ],
          //         ),
          //       ),
          //       // Tab bar content (Login and Sign Up)
          //       Expanded(
          //         child: TabBarView(
          //           children: [
          //             // Login Tab
          //             monthlyWidget(),
          //             // Sign Up Tab
          //             monthlyWidget(),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
    );
  }

  bool ischecked = false;

  Widget monthlyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          SubscriptionOption(
            title: 'Free Tier',
            price: '₹100',
            isChecked: planId == 1,
            description: 'Lorem ipsum dolor sit amet',
            discount: 'selected',
            isDiscounted: false,
            onTap: () {
              debugPrint("ontap----");
              setState(() {
                // ischecked = !ischecked;
                planId = 1;
                setState(() {

                });
              });
              // Subscription logic for Free Tier
            },
          ),
          SubscriptionOption(
            title: planList?[0].planName ?? "",
            price: '₹200',
            isChecked:  planId == 2,
            description: planList[0].discription ?? "",
            isDiscounted: true,
            discount: 'For You 50% OFF',
            onTap: () {
              planId = 2;
              setState(() {
              });
              // Subscription logic for Single User Tier
            },
          ),
          SubscriptionOption(
            title: 'Small Team Tier',
            price: '₹400',
            isChecked:  planId == 3,
            description: 'Lorem ipsum dolor sit amet',
            isDiscounted: false,
            onTap: () {
              planId = 3;
              setState(() {

              });
              // Subscription logic for Small Team Tier
              setState(() {
                ischecked = !ischecked;
              });
            },
          ),
          SubscriptionOption(
            title: 'Big Team Tier',
            price: '₹800',
            isChecked:  planId == 4,
            description: 'Lorem ipsum dolor sit amet',
            isDiscounted: false,
            onTap: () {
              planId = 4;
              setState(() {

              });
              // Subscription logic for Big Team Tier
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Subscription action
              submitPlanId();
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
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Skip for now logic
              submitPlanId();
            },
            child:  Text(
                AppLocalizations.of(context).translate('skipForNow'),
              style: TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final String? discount;
  final bool isDiscounted;
  final bool isChecked;
  final VoidCallback onTap;

  const SubscriptionOption({super.key, 
    required this.title,
    required this.price,
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
                          Flexible(
                            child: SizedBox(
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
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                        "/month",
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
