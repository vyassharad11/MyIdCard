import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_di_card/bloc/cubit/auth_cubit.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import '../../bloc/api_resp_state.dart';
import '../../language/app_localizations.dart';
import '../../models/utility_dto.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';


class HelpAndSupport extends StatefulWidget {
  HelpAndSupport({Key? key}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  AuthCubit? settingCubit;

  @override
  void initState() {
    settingCubit = AuthCubit(AuthRepository());
    super.initState();
  }

  @override
  void dispose() {
    settingCubit?.close();
    settingCubit = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, ResponseState>(
          bloc: settingCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
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
              Navigator.pop(context);
              Utility().showFlushBar(context: context, message: "Your message sent successfully!");
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          foregroundColor: Colors.white,
          backgroundColor: ColoursUtils.background,
          title: Text(
            AppLocalizations.of(context).translate('helpAndSupport'),
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: _getBody(),
      ),
    );
  }

  _getBody() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top +20,right: 16,left: 16,bottom: 20),
      child: 
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(52),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2.0),
                      ),
                    ],
                    border:Border.all( width: 0.5),),
                    padding: const EdgeInsets.only(
                        left: 15,
                        right:10,
                        top: 5,
                        bottom: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: TextField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      decoration: InputDecoration(
                        hintText:
                        AppLocalizations.of(context).translate('enterTitle'),
                        border: InputBorder.none,
                      ),
                    )
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 2.0),
                        ),
                      ],
                      border:Border.all( width: 0.5),),
                    padding: const EdgeInsets.only(
                        left: 15,
                        right:10,
                        top: 5,
                        bottom: 5),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    child: TextField(
                      textInputAction: TextInputAction.newline,
                      // keyboardType: TextInputType.text,
                      textCapitalization:
                      TextCapitalization.sentences,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      controller: _descriptionController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(250),
                      ],
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.only(top: 10),
                        hintText:
                        AppLocalizations.of(context).translate('enterDescription'),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            // iconAlignment: IconAlignment.start,
                            onPressed: () {
                              if (validate()) {
                                Utility.hideKeyboard(context);
                                Utility.showLoader(context);
                                apiHelpAndSupport();
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
                                  AppLocalizations.of(context)
                                      .translate('submit'),
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),),
                ]),
          ),
             

        );
  }

  apiHelpAndSupport() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();


    Map<String, dynamic> data = {
      "subject": title,
      "message": description,
    };
    settingCubit?.apiSupport(data);
  }

  bool validate() {
    var valid = true;
    List<String>? messages = [];

    if (_titleController.text.trim().isEmpty) {
      valid = false;
      messages.add("Please enter title.");
    } else if (_titleController.text.trim().length < 5) {
      valid = false;
      messages.add("Title length should be at least 5 characters.");
    }

    if (_descriptionController.text.trim().isEmpty) {
      valid = false;
      messages.add("Please enter description.");
    } else if (_descriptionController.text.trim().length < 20) {
      valid = false;
      messages.add("Description length should be at least 20 characters.");
    }

    if (!valid) {
      var msg = "";
      for (String message in messages) {
        if (msg.isEmpty) {
          msg = message;
        } else {
          msg = "$msg\n$message";
        }
      }
      Utility().showFlushBar(context: context, message: msg, isError: true);
    }
    return valid;
  }
}
