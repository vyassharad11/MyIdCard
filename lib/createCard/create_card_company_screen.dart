import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/card_cubit.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../bloc/api_resp_state.dart';
import '../bloc/cubit/auth_cubit.dart';
import '../language/app_localizations.dart';
import '../models/card_get_model.dart';
import '../models/company_model.dart';
import '../models/company_type_model.dart';
import '../utils/colors/colors.dart';
import '../utils/image_cropo.dart';
import '../utils/utility.dart';
import '../utils/widgets/network.dart';
import 'create_card_social.dart';
import 'package:dio/dio.dart';


class CreateCardScreen2 extends StatefulWidget {
  final String cardId;
  final bool isEdit;
  const CreateCardScreen2(
      {super.key, required this.cardId, required this.isEdit});

  @override
  State<CreateCardScreen2> createState() => _CreateCardScreen2State();
}

class _CreateCardScreen2State extends State<CreateCardScreen2> {
  TextEditingController companyName = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController companyAddress = TextEditingController();
  TextEditingController companyWebsite = TextEditingController();
  TextEditingController workEmail = TextEditingController();
  TextEditingController workPhone = TextEditingController();
  String token = "";
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  CardCubit? _updateCardCubit,_getGetCompanyTypeCubit,_getCardCubit;
  List<DataCompany> companyList = []; // List to hold parsed data
  String? selectedId = "1"; // Holds the selected ID
  String? selectedTitle; // Holds the selected title

  @override
  void dispose() {
    _updateCardCubit?.close();
    _getCardCubit?.close();
    _getGetCompanyTypeCubit?.close();
    _updateCardCubit = null;
    _getCardCubit = null;
    _getGetCompanyTypeCubit = null;
    companyAddress.dispose();
    companyName.dispose();
    jobTitle.dispose();
    companyWebsite.dispose();
    workEmail.dispose();
    workPhone.dispose();

    super.dispose();
  }

  void getUserToken() async {
    await Storage().getToken().then((ca) {
      setState(() {
        token = ca;
      });
    });
  }

  @override
  void initState() {
    _updateCardCubit = CardCubit(CardRepository());
    _getGetCompanyTypeCubit = CardCubit(CardRepository());
    _getCardCubit = CardCubit(CardRepository());
    getUserToken();
    if (widget.isEdit) {
      fetchEditData();
      fetchData();
    } else {
      fetchData();
    }
    super.initState();
  }

  Future<void> fetchEditData() async {
    _getCardCubit?.apiGetCard(widget.cardId);
  }

  String? validateFields({
    required String stepNo,
    required String companyName,
    required String companyTypeId,
    required String jobTitle,
    required String companyAddress,
    required String companyWebsite,
    required String workEmail,
    required String phoneNo,
  }) {
    // Check for empty fields
    if (stepNo.isEmpty) return "Step number is required.";
    if (companyName.isEmpty) return "Company name is required.";
    if (companyTypeId.isEmpty) return "Company type is required.";
    if (jobTitle.isEmpty) return "Job title is required.";
    if (companyAddress.isEmpty) return "Company address is required.";
    if (workEmail.isEmpty) return "Work email is required.";
    if (phoneNo.isEmpty) return "Phone number is required.";

    // Validate email format
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(workEmail)) return "Enter a valid email address.";

    // Validate phone number format (example: 10 digits)
    if (phoneNo.length != 10 || int.tryParse(phoneNo) == null) {
      return "Enter a valid 10-digit phone number.";
    }

    // Validate website URL (optional, if required)
    // if (companyWebsite.isNotEmpty) {
    //   final websiteRegex = RegExp(
    //       r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    //   if (!websiteRegex.hasMatch(companyWebsite)) {
    //     return "Enter a valid website URL.";
    //   }
    // }

    // All validations passed
    return null;
  }

  Future<void> submitData() async {
    final validationError = validateFields(
      stepNo: "2",
      companyName: companyName.text.toString().trim(),
      companyTypeId: selectedId.toString().trim(),
      jobTitle: jobTitle.text.toString().trim(),
      companyAddress: companyAddress.text.toString().trim(),
      companyWebsite: companyWebsite.text.toString().trim(),
      workEmail: workEmail.text.toString().trim(),
      phoneNo: workPhone.text.toString().trim(),
    );

    if (validationError != null) {
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    // var   fileData;
    // if (_selectedImage != null &&
    //           _selectedImage!.path != "" &&
    //           !_selectedImage!.path.contains("storage")) {
    //   fileData = await http.MultipartFile.fromPath(
    //           'company_logo',
    //           _selectedImage?.path ?? "",
    //         );
    //  }
    // Map<String, dynamic> data = {
    //   'step_no' : "2",
    //   'company_name' : companyName.text.toString().trim(),
    //   'company_type_id' : selectedId.toString().trim(),
    //   'job_title' :  jobTitle.text.toString().trim(),
    //   'company_address' : companyAddress.text.toString().trim(),
    //   'company_website' : companyWebsite.text.toString().trim(),
    //   'work_email' : workEmail.text.toString().trim(),
    //   'phone_no' : workPhone.text.toString().trim(),
    //   'company_logo':fileData.toString()
    // };
    Utility.showLoader(context);
    var data=null;
    if (_selectedImage != null &&
        _selectedImage!.path != "" &&
        !_selectedImage!.path.contains("storage")) {
      data = FormData.fromMap({
       if(_selectedImage != null && _selectedImage!.path.isNotEmpty) 'company_logo':
        await MultipartFile.fromFile(_selectedImage!.path, filename: "demo.png"),
        'step_no' : "2",
        'company_name' : companyName.text.toString().trim(),
        'company_type_id' : selectedId.toString().trim(),
        'job_title' :  jobTitle.text.toString().trim(),
        'company_address' : companyAddress.text.toString().trim(),
        'company_website' : companyWebsite.text.toString().trim(),
        'work_email' : workEmail.text.toString().trim(),
        'phone_no' : workPhone.text.toString().trim(),
      });
    }else{
      data = FormData.fromMap({
        'step_no' : "2",
        'company_name' : companyName.text.toString().trim(),
        'company_type_id' : selectedId.toString().trim(),
        'job_title' :  jobTitle.text.toString().trim(),
        'company_address' : companyAddress.text.toString().trim(),
        'company_website' : companyWebsite.text.toString().trim(),
        'work_email' : workEmail.text.toString().trim(),
        'phone_no' : workPhone.text.toString().trim(),
      });
    }

    _updateCardCubit?.cardUpdateApi(data,widget.cardId,);



    // try {
    //   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    //
    //   // Add fields to the request
    //   request.fields['step_no'] = "2";
    //   request.fields['company_name'] = companyName.text.toString().trim();
    //   request.fields['company_type_id'] = selectedId.toString().trim();
    //   request.fields['job_title'] = jobTitle.text.toString().trim();
    //   request.fields['company_address'] = companyAddress.text.toString().trim();
    //   request.fields['company_website'] = companyWebsite.text.toString().trim();
    //   request.fields['work_email'] = workEmail.text.toString().trim();
    //   request.fields['phone_no'] = workPhone.text.toString().trim();
    //
    //   // Add the image to the request
    //   if (_selectedImage != null &&
    //       _selectedImage!.path != "" &&
    //       !_selectedImage!.path.contains("storage")) {
    //     var file = await http.MultipartFile.fromPath(
    //       'company_logo',
    //       _selectedImage?.path ?? "",
    //     );
    //
    //     request.files.add(file);
    //   }
    //
    //   // Add headers, including Authorization token
    //   request.headers.addAll({
    //     'Authorization': 'Bearer $token',
    //     'Accept': 'application/json',
    //   });
    //   var response = await request.send();
    //
    //   // Handle the response
    //   if (response.statusCode == 200) {
    //      Utility.hideLoader(context);
    //
    //
    //   } else {
    //      Utility.hideLoader(context);
    //     print(
    //         "Failed to submit data. Status Code: ${response.statusCode} \n $response");
    //   }
    // } catch (error) {
    //    Utility.hideLoader(context);
    //
    //   debugPrint("An error occurred: $error");
    // }
  }

  CompanyTypeModel? companyTypeModel;
  Future<void> fetchData() async {
    _getGetCompanyTypeCubit?.apiGetCompanyType();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CardCubit, ResponseState>(
          bloc: _updateCardCubit,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => CreateCardScreenSocial(
                            cardId: widget.cardId,
                            isEdit: widget.isEdit,
                          )));
              Utility().showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },
        ) ,

        BlocListener<CardCubit, ResponseState>(
          bloc: _getGetCompanyTypeCubit,
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
              var dto = state.data as CompanyTypeModel;
              companyTypeModel = dto;
              companyList = dto.data ?? [];
            }
            setState(() {});
          },
        ),
        BlocListener<CardCubit, ResponseState>(
          bloc: _getCardCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as GetCardModel;
              if (dto.data?.companyTypeId.toString() == "1") {
                selectedTitle = "IT";
                selectedId = "1";
              } else {
                selectedTitle = "Finance";
                selectedId = "2";
              }

              companyName.text = dto.data?.companyName ?? "";
              jobTitle.text = dto.data?.jobTitle ?? "";
              companyAddress.text = dto.data?.companyAddress ?? "";
              companyWebsite.text = dto.data?.companyWebsite ?? "";
              workEmail.text = dto.data?.workEmail ?? "";
              workPhone.text = dto.data?.phoneNo ?? "";

              if (dto.data?.company_logo != null) {
                _selectedImage = File(dto.data?.company_logo);
              }
            }
            setState(() {});
          },
        ),
      ],
        child: GestureDetector(
          onTap: CommonUtils.closeKeyBoard,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.pop(context), // Default action: Go back
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 2,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context).translate('createCardOn'),
                            style:
                                TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 3,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 30,
                          height: 3,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 10,
                          height: 3,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 10,
                          height: 3,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 10,
                          height: 3,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .translate('companyDetails'),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: Stack(
                          children: [
                            _selectedImage != null &&
                                    _selectedImage!.path.isNotEmpty &&
                                    !_selectedImage!.path.contains("storage")
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        50), // Adjust the radius as needed
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    ),
                                  )
                                : _selectedImage != null &&
                                        _selectedImage!.path.isNotEmpty &&
                                        _selectedImage!.path.contains("storage")
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            50), // Adjust the radius as needed
                                        child: Image.network(
                                          "${Network.imgUrl}${_selectedImage!.path}",
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      )
                                    : Container(
                                        width: 80, // Adjust the size as needed
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: ColoursUtils
                                              .background, // Grey background color
                                          shape: BoxShape.circle, // Circular shape
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(22.0),
                                          child: Image.asset(
                                            "assets/images/image-01.png",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                            // Positioned plus icon at the bottom right corner
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .blue, // Background color of the plus icon
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors
                                        .white, // White border around the plus icon
                                    width: 3,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(
                                      4.0), // Padding around the plus icon
                                  child: Icon(
                                    Icons.add, // Plus icon
                                    size: 12, // Size of the plus icon
                                    color: Colors.white, // Color of the plus icon
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context).translate('companylogo'),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: companyName,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('companyname'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    companyList.isEmpty
                        ? SizedBox() // Show a loader until data is available
                        : selectedTitle != null && selectedTitle!.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  showBottomSheetCompanyType();
                                },
                                child: titleShewoEdt())
                            : companyTypeBottomSheet(context),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: jobTitle,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('jobtitle'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: companyAddress,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('companyaddress'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: companyWebsite,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate('companyWebsite'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: workEmail,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('workemail'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColoursUtils.background, // Light white color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: workPhone,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context).translate('phoneumber'),
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                       // iconAlignment: IconAlignment.start,
                        onPressed: () {
                          // Handle button press
                          submitData();
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
                            .translate('continue'), // Right side text
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

// Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close the bottom sheet
    getUserToken();
    // Request permission
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : androidInfo.version.sdkInt <= 32
              ? await Permission.storage.request()
              : await Permission.photos.request();

      if (permissionStatus.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(source: source);
          if (pickedFile != null) {
            final value = await imageCropperFunc(pickedFile.path);
            setState(() {
              _selectedImage = File(value.path);
            });
            debugPrint("Image Path: ${pickedFile.path}");
          }
        } catch (e) {
          debugPrint("Error picking image: $e");
        }
      } else {
        debugPrint("Permission denied.");

        _showPermissionDeniedMessage();
      }
    } else if (Platform.isIOS) {
      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.photos.request();
      if (permissionStatus.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(source: source);
          if (pickedFile != null) {
            final value = await imageCropperFunc(pickedFile.path);
            setState(() {
              _selectedImage = File(value.path);
            });
            debugPrint("Image Path: ${pickedFile.path}");
          }
        } catch (e) {
          debugPrint("Error picking image: $e");
        }
      } else {
        debugPrint("Permission denied.");
        _showPermissionDeniedMessage();
      }
    }
  }

  // Function to show permission denied message
  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate('permissionText'),),
      ),
    );
  }

  Widget companyTypeBottomSheet(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheetCompanyType();
      },
      child: titleShewo(),
    );
  }

  void showBottomSheetCompanyType() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                  AppLocalizations.of(context)
                      .translate('selectCompanyType'),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: companyList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = companyList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedId = item.id.toString(); // Update selected ID
                        selectedTitle = item.companyType ?? "";
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        item.companyType!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget titleShewo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70, width: 1),
        color: ColoursUtils.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedId == null || selectedId!.isEmpty
                ? AppLocalizations.of(context)
          .translate('selectCompanyType')
                : companyList
                    .firstWhere((item) => item.id.toString() == selectedId)
                    .companyType!,
            style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 16,
              color: selectedId == null ||
                      selectedId!.isEmpty && selectedTitle == null
                  ? Colors.grey[500]
                  : Colors.black,
            ),
          ),
          Image.asset(
            "assets/images/chevron-down.png",
            height: 20,
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget titleShewoEdt() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70, width: 1),
        color: ColoursUtils.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedTitle!,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Image.asset(
            "assets/images/chevron-down.png",
            height: 20,
            width: 20,
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option for using the camera
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Image.asset(
                  "assets/images/camera-01.png",
                  width: 20,
                  height: 20,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child:  Text(AppLocalizations.of(context)
                      .translate('useCamera'),),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  // Add your logic for opening the camera
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              // Option for choosing from the library
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Image.asset(
                  "assets/images/image-plus.png",
                  width: 20,
                  height: 20,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child:  Text(AppLocalizations.of(context)
                      .translate('chooseFromLibrary'),),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  // Add your logic for picking an image from the gallery
                },
              ),
              if(_selectedImage != null) ...[
                const Divider(color: Colors.grey),
                // Remove Picture
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.delete_outline),
                  title:  Text(AppLocalizations.of(context)
                      .translate('removePicture'),),
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
