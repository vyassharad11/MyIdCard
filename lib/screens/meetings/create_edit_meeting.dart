import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/models/utility_dto.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../models/meeting_details_model.dart';
import '../../models/my_meetings_model.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';

class CreateEditMeeting extends StatefulWidget {
  bool? isEdit;
  MeetingDetailsModel? meetingDatum;
  String? contactId;
  String? meetingId;
  CreateEditMeeting({super.key,this.isEdit = false,this.meetingDatum,this.contactId,this.meetingId});

  @override
  State<CreateEditMeeting> createState() => _CreateEditMeetingState();
}

class _CreateEditMeetingState extends State<CreateEditMeeting> {
  TextEditingController titleController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  DateTime? selectedDateTime;
  ContactCubit? _createMeetingCubit;

  @override
  void initState() {
    _createMeetingCubit = ContactCubit(ContactRepository());
    if(widget.isEdit == true){
      setData();
    }
    // TODO: implement initState
    super.initState();
  }

  apiCreateMeeting(){
    Map<String, dynamic> body = {
      "contact_id": widget.contactId,
      "date_time":  DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!),
      "address": addController.text,
      "link": linkController.text,
      "notes":notesController.text,
      "title":titleController.text,
       "purpose":purposeController.text

    };
    _createMeetingCubit?.apiCreateMeeting(body);
  }

  apiUpdateMeeting(){
    Map<String, dynamic> body = {
      "contact_id": widget.contactId,
      "date_time":  DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!),
      "address": addController.text,
      "link": linkController.text,
      "notes":notesController.text,
      "title":titleController.text,
      "purpose":purposeController.text

    };
    _createMeetingCubit?.apiUpdateMeeting(body,widget.meetingId);
  }


   setData(){
    notesController.text = widget.meetingDatum?.data?.notes ?? "";
    addController.text = widget.meetingDatum?.data?.address ?? "";
    linkController.text = widget.meetingDatum?.data?.link ?? "";
    titleController.text = widget.meetingDatum?.data?.title ?? "";
    purposeController.text = widget.meetingDatum?.data?.purpose ?? "";
    selectedDateTime = widget.meetingDatum?.data?.dateTime ;
    setState(() {

    });
}
  Future<void> _selectDateTime(BuildContext context) async {
    // Show Date Picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime != null ? selectedDateTime : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    // Show Time Picker
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // Combine Date and Time
    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: _createMeetingCubit,
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
          },
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              "${widget.isEdit == true ? "Edit":"Create"} Meeting",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColoursUtils.background, // Light white color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
                Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColoursUtils.background, // Light white color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: purposeController,
                decoration: const InputDecoration(
                  hintText: 'Enter purpose',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
                Container(
              height: 120,
              decoration: BoxDecoration(
                color: ColoursUtils.background, // Light white color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                maxLines: 4,
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: 'Enter notes',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColoursUtils.background, // Light white color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: addController,
                decoration: const InputDecoration(
                  hintText: 'Enter address',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColoursUtils.background, // Light white color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  hintText: 'Enter meeting link',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
              InkWell(
                onTap: (){
                  _selectDateTime(context);
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColoursUtils.background, // Light white color
                      borderRadius: BorderRadius.circular(8),
                    ),
                child: Center(
                  child: Text( selectedDateTime == null
                      ? 'Selected date and time'
                      : DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!),
                    style: const TextStyle(fontSize: 18),),
                ),
                ),
              ) ,
                SizedBox(height: 12,),
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    // iconAlignment: IconAlignment.start,
                    onPressed: () {
                          if(titleController.text.isNotEmpty && purposeController.text.isNotEmpty &&  selectedDateTime != null){
                            Utility.showLoader(context);
                           widget.isEdit == false ? apiCreateMeeting():apiUpdateMeeting();
                        } else {
                          Fluttertoast.showToast(msg:
                          titleController.text.isEmpty?
                          "Please enter title":
                          purposeController.text.isEmpty?
                          "Please enter purpose":
                          "Please select date"
                          );
                        }
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.isEdit == false ?"Create":"Update", // Right side text
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
          ]))),
    );
  }
}
