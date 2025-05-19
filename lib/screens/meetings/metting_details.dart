import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../language/app_localizations.dart';
import '../../models/meeting_details_model.dart';
import '../../models/my_meetings_model.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
import 'create_edit_meeting.dart'; // To open the meeting link

class MeetingDetailsScreen extends StatefulWidget {
  int? meetingId;
  String?contactId;
   MeetingDetailsScreen({super.key,this.meetingId,this.contactId});

  @override
  State<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  ContactCubit?_getMeetingCubit,deleteMeetingCubit;
  MeetingDetailsModel?meetingDetailsModel;

  @override
  void initState() {
    _getMeetingCubit = ContactCubit(ContactRepository());
    deleteMeetingCubit = ContactCubit(ContactRepository());
    apiGetMeetingDetails();
    // TODO: implement initState
    super.initState();
  }

  apiGetMeetingDetails(){
    _getMeetingCubit?.apiGetMeetingDetails(widget.meetingId?? 0);
  }

  apiDeleteMeeting(){
    deleteMeetingCubit?.apiDeleteMeeting(widget.meetingId?? 0);
  }


  @override
  Widget build(BuildContext context) {
    return
      MultiBlocListener(listeners: [
          BlocListener<ContactCubit, ResponseState>(
              bloc: _getMeetingCubit,
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
          var dto = state.data as MeetingDetailsModel;
          meetingDetailsModel = dto;
          }
          setState(() {});
          },),
        BlocListener<ContactCubit, ResponseState>(
          bloc: deleteMeetingCubit,
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
              var dto = state.data as UtilityDto;
            Navigator.pop(context);
            Utility().showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title:  Text(
            "${meetingDetailsModel?.data?.firstName ?? ""} ${AppLocalizations.of(context).translate('meeting')}",
            style: TextStyle(
                fontFamily: Constants.fontFamily,
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          meetingDetailsModel?.data?.title ?? "",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEditMeeting(
                                isEdit: true,
                                meetingDatum: meetingDetailsModel,
                                contactId: widget.contactId,
                                meetingId: widget.meetingId.toString(),
                              ),)).then((value) {
                                apiGetMeetingDetails();
                              },);
                              // showModalBottomSheet(
                              //   context: context,
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.vertical(
                              //       top: Radius.circular(25.0),
                              //     ),
                              //   ),
                              //   builder: (context) {
                              //     return BottomSheetContentAddContact();
                              //   },
                              // );
                            },
                            child: Image.asset(
                              "assets/images/edit-05.png",
                              height: 16,
                              width: 16,
                              color: Colors.black,
                            )),
                        SizedBox(width: 6,),
                        InkWell(
                            onTap: (){
                              showDeleteDialog(context);
                            },
                            child: Icon(Icons.delete_outline,color: Colors.black,size: 20,))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                                Icons.meeting_room_outlined, AppLocalizations.of(context).translate('meetingPurpose')),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 6),
                              child: Text(
                                meetingDetailsModel?.data?.purpose ?? "",
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                                Icons.calendar_month_outlined, 'Date & Time'),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 6),
                              child: Text(
                                  DateFormat('d MMMM yyyy').format(meetingDetailsModel?.data?.dateTime ?? DateTime.now()),
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(Icons.location_city, AppLocalizations.of(context).translate('address')),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 6),
                              child: Text(meetingDetailsModel?.data?.address ?? "",
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(Icons.link, AppLocalizations.of(context).translate('link')),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 6),
                              child: InkWell(
                                onTap: () => _launchURL( meetingDetailsModel?.data?.link ?? "",),
                                child: Text(
                                  meetingDetailsModel?.data?.link ?? "",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(Icons.notes, AppLocalizations.of(context).translate('notes')),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 6),
                              child: Text(meetingDetailsModel?.data?.notes ?? "",
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('deleteMeeting')),
          content: Text(AppLocalizations.of(context).translate('deleteMeetingAlert')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
                Utility.showLoader(context);
                apiDeleteMeeting();
              },
              child: Text(AppLocalizations.of(context).translate('delete')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context).translate('cancel')),
            ),
          ],
        );
      },
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black54,
          size: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Method to open the meeting link in the browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class BottomSheetContentAddContact extends StatelessWidget {
  static const List<String> items = [
    'Add to private contact',
    'Export to Contacts App',
  ];

  const BottomSheetContentAddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        color: Colors.white,
      ),
      child: ListView.separated(
        shrinkWrap: true, // Limits the ListView's height
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              items[index],
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () {
              debugPrint('${items[index]} ${AppLocalizations.of(context).translate('tapped')}');
              Navigator.pop(context); // Close the bottom sheet after tap
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}
