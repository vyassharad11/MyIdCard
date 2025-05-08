import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/models/card_get_model.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../bloc/api_resp_state.dart';
import '../bloc/cubit/card_cubit.dart';
import '../language/app_localizations.dart';
import '../localStorage/storage.dart';
import '../models/utility_dto.dart';
import '../screens/contact/document_preivew.dart';
import '../utils/utility.dart';
import '../utils/widgets/network.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'create_card_final_preview.dart';
import '../models/card_get_model.dart' as dataModel;

class CreateCardScreenDetailsOther extends StatefulWidget {
  final String cardId;
  final bool isEdit;
  const CreateCardScreenDetailsOther(
      {super.key, required this.cardId, required this.isEdit});

  @override
  State<CreateCardScreenDetailsOther> createState() =>
      _CreateCardScreenDetailsOtherState();
}

class _CreateCardScreenDetailsOtherState
    extends State<CreateCardScreenDetailsOther> {
  dataModel.Data? getCardModel;
  CardCubit? _updateCubit,_getCardCubit;

  @override
  initState(){
    _updateCubit = CardCubit(CardRepository());
    _getCardCubit = CardCubit(CardRepository());
    if (widget.isEdit) {
      fetchEditData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _updateCubit = null ;
    _getCardCubit = null ;
    _getCardCubit?.close();
    _updateCubit?.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
      BlocListener<CardCubit, ResponseState>(
          bloc: _updateCubit,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => CreateCardFinalPreview(
                        cardId: widget.cardId.toString() ?? "",
                        isEdit: true,
                      )));
            }
            setState(() {});},),
      BlocListener<CardCubit, ResponseState>(
          bloc: _getCardCubit,
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
              var dto = state.data as GetCardModel;
              dto.data?.cardDocuments?.forEach((action) {
                _selectedImage.add(File(action.document.toString()));});
            }
            setState(() {});},),],
        child: Scaffold(
          backgroundColor: ColoursUtils.whiteLightColor.withOpacity(1.0),
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
                            elevation: 0,
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
                    height: 20,
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
                        width: 10,
                        height: 3,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 10,
                        height: 3,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate('otherinfo'),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        builder: (context) {
                          return _buildBottomSheetContent();
                        },
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top + Icon
                            CircleAvatar(
                              radius: 18,
                              child: Image.asset("assets/images/add button.png"),
                            ),
                            const SizedBox(
                                height: 20), // Space between icon and text
                            // Text below the icon
                             Text(
                              AppLocalizations.of(context)
                                  .translate('upload'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                                height: 4), // Space between icon and text
                            // Text below the icon
                            Text(
                              AppLocalizations.of(context).translate('addfile'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  if (_selectedImage.isNotEmpty)
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 8),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('yourupload'),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 1,
                              color: ColoursUtils.background,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            if (_selectedImage.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (crtx, index) {
                                  return Container(
                                    height: 1,
                                    color: ColoursUtils.background,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                itemCount: _selectedImage.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      if(
                                      _selectedImage[index].path.contains("png") ||
                                          _selectedImage[index].path.contains("jpg") ||
                                          _selectedImage[index].path.contains("jpeg")
                                      ) {
                                      Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                      DocumentPreview(
                                      imageUrl: _selectedImage[index].path ?? "",),));
                                      // Handle delete action
                                      }else {
                                        await OpenFilex.open(_selectedImage[index].path ?? "");
                                      }
                                    },
                                    child: ListTile(
                                      contentPadding:
                                          EdgeInsets.only(left: 12, right: 6),
                                      leading: _selectedImage[index]
                                                  .path
                                                  .contains(".pdf") ||
                                              _selectedImage[index]
                                                  .path
                                                  .contains(".docx")
                                          ? Icon(
                                              Icons.picture_as_pdf,
                                              size: 24,
                                              color: Colors.black,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  15), // Rounded corners for image
                                              child: _selectedImage[index]
                                                      .path
                                                      .contains("storage")
                                                  ? Image.network(
                                                      "${Network.imgUrl}${_selectedImage[index].path}",
                                                      fit: BoxFit.cover,
                                                      width: 40,
                                                      height: 40,
                                                    )
                                                  : Image.file(
                                                      _selectedImage[index],
                                                      fit: BoxFit.cover,
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                            ),
                                      title: _selectedImage[index].path.isNotEmpty
                                          ? Text(
                                              _selectedImage[index].path.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : Text("-"),
                                      trailing: IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Image.asset(
                                              "assets/images/Frame 415.png"),
                                        ),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            _selectedDElecImage
                                                .add(_selectedImage[index]);
                                            _selectedImage.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                       // iconAlignment: IconAlignment.start,
                        onPressed: () {
                          Utility.showLoader(context);
                          submitData();
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
                                .translate('submit'),// Right side text
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Future<void> fetchEditData() async {
    _getCardCubit?.apiGetCard(widget.cardId);
  }




  // Future<void> submitData() async {
  //
  //   Utility.showLoader(context);
  //   var data=null;
  //
  //   for (int i = 0; i < _selectedImage.length; i++) {
  //     if (!_selectedImage[i].path.contains("storage")) {
  //       data = FormData.fromMap({
  //         'documents[$i]':
  //         await MultipartFile.fromFile(_selectedImage[i].path, filename: "demo.png"),
  //       });
  //     }
  //   }
  //   for (int i = 0; i < _selectedDElecImage.length; i++) {
  //     if (!_selectedDElecImage[i].path.contains("storage")) {
  //       data = FormData.fromMap({
  //         'delete_document_id[$i]':
  //         await MultipartFile.fromFile(_selectedDElecImage[i].path, filename: "demo.png"),
  //       });
  //     }
  //   }
  //
  //     data = FormData.fromMap({'step_no' : "5",
  //     });
  //
  //
  //   _updateCubit?.cardUpdateApi(data, widget.cardId);
  //
  // }

  Future<void> submitData() async {
    var token = await Storage().getToken();
    String apiUrl =
        "${Network.baseUrl}card/update/${widget.cardId}"; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields['step_no'] = "5";
      for (int i = 0; i < _selectedImage.length; i++) {
        if (!_selectedImage[i].path.contains("storage")) {
          var file = await http.MultipartFile.fromPath(
            'documents[$i]',
            _selectedImage[i].path,
          );
          request.files.add(file);
        }

        // Add the file to the request
      }

      for (int i = 0; i < _selectedDElecImage.length; i++) {
        var file = await http.MultipartFile.fromPath(
          'delete_document_id[$i]',
          _selectedDElecImage[i].path,
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
         Utility.hideLoader(context);

        debugPrint("Data submitted successfully: ");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => CreateCardFinalPreview(
                      cardId: widget.cardId.toString() ?? "",
                  isEdit: true,
                    )), (route) => false,);
      } else {
         Utility.hideLoader(context);
        print(
            "Failed to submit data. Status Code: ${response.statusCode} \n $response");
      }
    } catch (error) {
       Utility.hideLoader(context);

      debugPrint("An error occurred: $error");
    }
  }

  Future<void> selectFile() async {
    // Use FilePicker to select a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedImage.add(File(result.files.single.path!));
      });
    }
  }

  Widget _buildBottomSheetContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: Image.asset(
              "assets/images/credit-card-02.png",
              width: 24,
              color: Colors.black,
              height: 24,
            ),
            title:  Text(AppLocalizations.of(context)
                .translate('uploadPhysicalCard'),),
            onTap: () {
              _pickImage(ImageSource.gallery);

              // Handle Upload Physical Card action
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: Image.asset(
              "assets/images/camera-01.png",
              width: 24,
              color: Colors.black,
              height: 24,
            ),
            title:  Text(AppLocalizations.of(context)
                .translate('useCamera'),),
            onTap: () {
              _pickImage(ImageSource.camera);

              // Handle Use Camera action
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: Image.asset(
              "assets/images/image-plus.png",
              width: 24,
              color: Colors.black,
              height: 24,
            ),
            title:  Text(AppLocalizations.of(context)
                .translate('uploadPhotos'),),
            onTap: () {
              _pickImage(ImageSource.gallery);
              // Handle Upload Photos action
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: Image.asset(
              "assets/images/file-06.png",
              color: Colors.black,
              width: 24,
              height: 24,
            ),
            title:  Text(AppLocalizations.of(context)
                .translate('uploadFiles'),),
            onTap: () {
              // Handle Upload Files action
              selectFile();
            },
          ),
          // const Divider(
          //   color: Colors.grey,
          // ),
          // ListTile(
          //   contentPadding: EdgeInsets.zero,
          //   leading: Image.asset(
          //     "assets/images/scan.png",
          //     width: 24,
          //     color: Colors.black,
          //     height: 24,
          //   ),
          //   title: const Text('Scan Document'),
          //   onTap: () {
          //     // Handle Scan Document action
          //   },
          // ),
        ],
      ),
    );
  }



  final List<File> _selectedImage = [];
  final List<File> _selectedDElecImage = [];
  List<String> fileName = [];
  final ImagePicker _picker = ImagePicker();

// Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close the bottom sheet
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
            setState(() {
              _selectedImage.add(File(pickedFile.path));
              fileName.add(path.basename(pickedFile.path));
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
            setState(() {
              _selectedImage.add(File(pickedFile.path));
              fileName.add(path.basename(pickedFile.path.toString()));
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
}
