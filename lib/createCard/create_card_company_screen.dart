import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../language/app_localizations.dart';
import '../models/card_get_model.dart';
import '../models/company_model.dart';
import '../models/company_type_model.dart';
import '../utils/colors/colors.dart';
import '../utils/image_cropo.dart';
import '../utils/widgets/network.dart';
import 'create_card_social.dart';

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

  List<Company> companyList = []; // List to hold parsed data

  String? selectedId = "1"; // Holds the selected ID
  String? selectedTitle; // Holds the selected title

  @override
  void dispose() {
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
    var token = await Storage().getToken();
    String apiUrl =
        "${Network.baseUrl}card/get/${widget.cardId}"; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonResponse = jsonDecode(response.body);

        GetCardModel getCardModel = GetCardModel.fromJson(jsonResponse);
        setState(() {
          if (getCardModel.data?.companyTypeId == "1") {
            selectedTitle = "IT";
            selectedId = "1";
          } else {
            selectedTitle = "Finance";
            selectedId = "2";
          }

          companyName.text = getCardModel.data?.companyName ?? "";
          jobTitle.text = getCardModel.data?.jobTitle ?? "";
          companyAddress.text = getCardModel.data?.companyAddress ?? "";
          companyWebsite.text = getCardModel.data?.companyWebsite ?? "";
          workEmail.text = getCardModel.data?.workEmail ?? "";
          workPhone.text = getCardModel.data?.phoneNo ?? "";

          if (getCardModel.data?.company_logo != null) {
            debugPrint("${getCardModel.data?.company_logo}");
            _selectedImage = File(getCardModel.data?.company_logo);
          }
        });

        debugPrint("Data fetched successfully: $getCardModel");
        context.loaderOverlay.hide();
      } else {
        context.loaderOverlay.hide();

        // Handle error response
        debugPrint("Failed to fetch data. Status Code: ${response.statusCode}");
        debugPrint("Error: ${response.body}");
      }
    } catch (error) {
      context.loaderOverlay.hide();

      // Handle any exceptions
      debugPrint("An error occurred: $error");
    }
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

    context.loaderOverlay.show();

    String apiUrl =
        "${Network.baseUrl}card/update/${widget.cardId}"; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request
      request.fields['step_no'] = "2";
      request.fields['company_name'] = companyName.text.toString().trim();
      request.fields['company_type_id'] = selectedId.toString().trim();
      request.fields['job_title'] = jobTitle.text.toString().trim();
      request.fields['company_address'] = companyAddress.text.toString().trim();
      request.fields['company_website'] = companyWebsite.text.toString().trim();
      request.fields['work_email'] = workEmail.text.toString().trim();
      request.fields['phone_no'] = workPhone.text.toString().trim();

      // Add the image to the request
      if (_selectedImage != null &&
          _selectedImage!.path != "" &&
          !_selectedImage!.path.contains("storage")) {
        var file = await http.MultipartFile.fromPath(
          'company_logo',
          _selectedImage?.path ?? "",
        );

        request.files.add(file);
      }

      // Add headers, including Authorization token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        context.loaderOverlay.hide();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => CreateCardScreenSocial(
                      cardId: widget.cardId,
                      isEdit: widget.isEdit,
                    )));
      } else {
        context.loaderOverlay.hide();
        print(
            "Failed to submit data. Status Code: ${response.statusCode} \n $response");
      }
    } catch (error) {
      context.loaderOverlay.hide();

      debugPrint("An error occurred: $error");
    }
  }

  CompanyTypeModel? companyTypeModel;
  Future<void> fetchData() async {
    const String apiUrl =
        "${Network.baseUrl}companytype/get"; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });

      if (response.statusCode == 200) {
        // Successfully fetched data
        final data = jsonDecode(response.body);
        debugPrint("Data fetched successfully: $data");

        setState(() {
          companyTypeModel = CompanyTypeModel.fromJson(data);
          companyList = (data["data"] as List)
              .map((item) => Company.fromJson(item))
              .toList(); // Convert to a list of Company objects
        });
        context.loaderOverlay.hide();
      } else {
        context.loaderOverlay.hide();

        // Handle error response
        debugPrint("Failed to fetch data. Status Code: ${response.statusCode}");
        debugPrint("Error: ${response.body}");
      }
    } catch (error) {
      context.loaderOverlay.hide();

      // Handle any exceptions
      debugPrint("An error occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                const Center(
                  child: Text(
                    "Company Details",
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
                    iconAlignment: IconAlignment.start,
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Continue", // Right side text
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
      const SnackBar(
        content: Text('Permission denied. Please enable it from settings.'),
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
                'Select company type',
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
                ? "Select Company Type"
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
                  child: const Text('Use Camera'),
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
                  child: const Text('Choose from Library'),
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
                  title: const Text('Remove Picture'),
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
