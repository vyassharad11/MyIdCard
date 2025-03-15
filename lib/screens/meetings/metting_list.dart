import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/screens/meetings/metting_details.dart';
import 'package:intl/intl.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/card_cubit.dart';
import '../../models/my_meetings_model.dart';
import '../../utils/utility.dart';

class MeetingsScreen extends StatefulWidget {
  int contactId;
   MeetingsScreen({super.key,required this.contactId});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {

  ContactCubit? meetingCubit;
  List<MeetingDatum> meetings = [];

  @override
  void initState() {
    meetingCubit = ContactCubit(ContactRepository());
    apiGetMyMeetings();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    meetingCubit?.close();
    meetingCubit = null;
    // TODO: implement dispose
    super.dispose();
  }


  apiGetMyMeetings(){
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1,
    };
    meetingCubit?.apiGetMyMeetings(data);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: meetingCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as MyMeetingModel;
              meetings = [];
              meetings = dto.data?.data ?? [];
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Meeting",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: ListView.separated(
          separatorBuilder: (ctx, index) {
            return Container(
              color: Colors.black12,
              height: 1,
            );
          },
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final meeting = meetings[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) =>  MeetingDetailsScreen(meetingId: meetings[index].id ?? 0,contactId: widget.contactId.toString(),),
                  ),
                );
              },
              title: Text(
                meeting.title?? '',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                meeting.purpose ?? '',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                DateFormat('d MMMM yyyy').format(meeting.dateTime ?? DateTime.now()),
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            );
          },
        ),
      ),
    );
  }
}
