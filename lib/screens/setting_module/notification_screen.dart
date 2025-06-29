import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/auth_cubit.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/api_resp_state.dart';
import '../../models/notification_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/utility.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AuthCubit? notificationCubit,notificationDeleteCubit;
  bool isLoad = true;
  List<NotificationDatum> notificationList =[];
  int selectedIndex = 0;

  @override
  void initState() {
    notificationCubit = AuthCubit(AuthRepository());
    notificationDeleteCubit = AuthCubit(AuthRepository());
    apiGetNotification();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    notificationCubit?.close();
    notificationDeleteCubit?.close();
    notificationCubit = null;
    notificationDeleteCubit = null;
    // TODO: implement dispose
    super.dispose();
  }

  apiGetNotification(){
    notificationCubit?.apiGetNotification(10, 0);
  }

  apiDeleteNotification(id){
    notificationDeleteCubit?.apiDeleteNotification(id);
  }


  @override
  Widget build(BuildContext context) {
    return
      MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, ResponseState>(
            bloc: notificationCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {
              } else if (state is ResponseStateEmpty) {
                isLoad = false;
                Utility().showFlushBar(
                    context: context, message: state.message, isError: true);
              } else if (state is ResponseStateNoInternet) {
                isLoad = false;
                Utility().showFlushBar(
                    context: context, message: state.message, isError: true);
              } else if (state is ResponseStateError) {
                isLoad = false;
                Utility().showFlushBar(
                    context: context, message: state.errorMessage, isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as NotificationModel;
                if(dto != null && dto.data != null && dto.data!.isNotEmpty){
                  notificationList?.addAll(dto.data ?? []);
                }
                isLoad = false;
              }setState(() {

              });
            },
          ),
          BlocListener<AuthCubit, ResponseState>(
            bloc: notificationDeleteCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {
                Utility.showLoader(context);
              } else if (state is ResponseStateEmpty) {
                Utility.hideLoader(context);
                Utility().showFlushBar(
                    context: context, message: state.message, isError: true);
              } else if (state is ResponseStateNoInternet) {
                Utility.hideLoader(context);
                Utility().showFlushBar(
                    context: context, message: state.message, isError: true);
              } else if (state is ResponseStateError) {
                Utility.hideLoader(context);
                Utility().showFlushBar(
                    context: context, message: state.errorMessage, isError: true);
              } else if (state is ResponseStateSuccess) {
                Utility.hideLoader(context);
                var dto = state.data as UtilityDto;
                Utility().showFlushBar(context: context, message: dto.message ?? "");
                notificationList?.removeAt(selectedIndex);
              }setState(() {

              });
            },
          ),
        ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // Removes the default back button
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white60, // Notification icon background
                child: Icon(
                  Icons.close, // Notification icon
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        body:
            isLoad ? getShimmerView():
        notificationList != null &&  notificationList!.isNotEmpty ?
        ListView.separated(
          // padding: const EdgeInsets.all(8.0),
          itemCount: notificationList?.length ??0, // Example notification count
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue, // Notification icon background
                  child: Icon(
                    Icons.notifications, // Notification icon
                    color: Colors.white,
                  ),
                ),
                title: Text(notificationList?[index].title ?? ""),
                subtitle: Text(notificationList?[index].message ?? ""),
                trailing: GestureDetector(
                  onTap: () {
                    selectedIndex = index;
                    setState(() {

                    });
                    apiDeleteNotification(notificationList?[index].id);
                  },
                  child: Image.asset(
                    "assets/images/Frame 416.png",
                    height: 26,
                    width: 26,
                  ),
                ));
          },
        ):Center(child: Text("No Record Found"),),
      ),
    );
  }

  Widget getShimmerView(){
    return Shimmer.fromColors(
        baseColor: Color(0x72231532),
    highlightColor: Color(0xFF463B5C), child:
    ListView.separated(
      // padding: const EdgeInsets.all(8.0),
      itemCount: 20, // Example notification count
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: const CircleAvatar(
              backgroundColor: Colors.blue, // Notification icon background
              child: Icon(
                Icons.notifications, // Notification icon
                color: Colors.white,
              ),
            ),
            title: Container(height: 20,width: 100,
            decoration: BoxDecoration(color:  Color(0x72231532),borderRadius: BorderRadius.circular(4)),
            ),
            subtitle: Container(height: 14,width: 150,
              decoration: BoxDecoration(color:  Color(0x72231532),borderRadius: BorderRadius.circular(4)),
            ),
            trailing: Container(height: 26,width: 26,
              decoration: BoxDecoration(color:  Color(0x72231532),borderRadius: BorderRadius.circular(26)),
            ),);
      },
    )
    );
  }
}
