import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/models/background_image_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/api_resp_state.dart';
import '../bloc/cubit/card_cubit.dart';
import '../data/repository/card_repository.dart';
import '../language/app_localizations.dart';
import '../localStorage/storage.dart';
import '../models/card_get_model.dart';
import '../utils/utility.dart';
import '../utils/widgets/network.dart';
import 'create_card_details_other.dart';
import 'package:dio/dio.dart';

class CreateCardScreenDetails extends StatefulWidget {
  final String cardId;
  final bool isEdit;
   const CreateCardScreenDetails(
      {super.key, required this.cardId, required this.isEdit});

  @override
  State<CreateCardScreenDetails> createState() =>
      _CreateCardScreenDetailsState();
}

class _CreateCardScreenDetailsState extends State<CreateCardScreenDetails> {
  TextEditingController cardName = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _selectedImagePath;
  CardCubit? _getCardCubit,_updateCardCubit,_getBackgroundImageCubit;
  List<BgDatum>? backgroundImageList;

  @override
  void initState() {
    _getCardCubit = CardCubit(CardRepository());
    _getBackgroundImageCubit = CardCubit(CardRepository());
    _updateCardCubit = CardCubit(CardRepository());
    apiGetBackgroundImage();
    if (widget.isEdit) {
      fetchEditData();
    }
    super.initState();
  }

  Future<void> fetchEditData() async {
    _getCardCubit?.apiGetCard(widget.cardId);
  }
Future<void> apiGetBackgroundImage() async {
    _getBackgroundImageCubit?.apiGetBackgroundImage();
  }


  @override
  Widget build(BuildContext context) {
    return
      MultiBlocListener(listeners: [
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
          cardName.text = dto.data?.cardName.toString() ?? "";
          if (dto.data?.backgroungImage != null) {
            _selectedImage = File(dto.data?.backgroungImage);
            _selectedImagePath = dto.data?.backgroungImage;
          }
          if (dto.data?.cardStyle != null) {
            _currentColor = Color(int.parse('0xFF${dto.data!.cardStyle!}'));
          }
        }
        setState(() {});
      },),
      BlocListener<CardCubit, ResponseState>(
      bloc: _getBackgroundImageCubit,
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
          var dto = state.data as BackgroundImageModel;
          if(dto != null && dto.data != null){
            backgroundImageList = dto.data;
          }
        }
        setState(() {});
      },),

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
                  builder: (builder) => CreateCardScreenDetailsOther(
                    cardId: widget.cardId,
                    isEdit: widget.isEdit,
                  )));
          Utility().showFlushBar(context: context, message: dto.message ?? "");
        }
        setState(() {});
      },),
      ],
      child: GestureDetector(
        onTap: CommonUtils.closeKeyBoard,
        child: Scaffold(
          backgroundColor: ColoursUtils.background,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
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
                            elevation: 3,
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate('CardDetail'),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white, // Light white color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: cardName,
                      // maxLength: 22,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).translate('CardName'),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.withOpacity(0.3), // Light white color
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: TextField(
                  //     controller: cardName,
                  //     decoration: InputDecoration(
                  //       hintText:
                  //           AppLocalizations.of(context).translate('CardName'),
                  //       border: InputBorder.none,
                  //       hintStyle: TextStyle(color: Colors.grey),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('CardStyle'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          // Space between text and row
                          ListTile(
                            title: Text(AppLocalizations.of(context)
                                .translate('selectCardColor'),),
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            onTap: colorPickerDialog,
                            trailing: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: _currentColor,
                                borderRadius: BorderRadius.circular(20),
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
                  // GestureDetector(
                  //   onTap: () => _showBottomSheet(context),
                  //   child: Card(
                  //     margin: EdgeInsets.zero,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(20), // Rounded corners
                  //     ),
                  //     elevation: 0,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 12.0, vertical: 12),
                  //       child: _selectedImage != null &&
                  //               _selectedImage!.path.isNotEmpty &&
                  //               !_selectedImage!.path.contains("storage")
                  //           ? SizedBox(
                  //               width: MediaQuery.of(context).size.width,
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(
                  //                     8), // Adjust the radius as needed
                  //                 child: Image.file(
                  //                   _selectedImage!,
                  //                   fit: BoxFit.cover,
                  //                   width: double.infinity,
                  //                   height: 180,
                  //                 ),
                  //               ),
                  //             )
                  //           : _selectedImage != null &&
                  //                   _selectedImage!.path.isNotEmpty &&
                  //                   _selectedImage!.path.contains("storage")
                  //               ? ClipRRect(
                  //                   borderRadius: BorderRadius.circular(
                  //                       8), // Adjust the radius as needed
                  //                   child: Image.network(
                  //                     "${Network.imgUrl}${_selectedImage!.path}",
                  //                     fit: BoxFit.cover,
                  //                     width: double.infinity,
                  //                     height: 180,
                  //                   ),
                  //                 )
                  //               : Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     // Top + Icon
                  //                     CircleAvatar(
                  //                       radius: 18,
                  //                       child: Image.asset(
                  //                           "assets/images/add button.png"),
                  //                     ),
                  //                     const SizedBox(
                  //                         height:
                  //                             20), // Space between icon and text
                  //                     // Text below the icon
                  //                     Text(
                  //                       AppLocalizations.of(context)
                  //                           .translate('background'),
                  //                       textAlign: TextAlign.center,
                  //                       style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.normal,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 10),
                  //                   ],
                  //                 ),
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () => _showBottomSheetForBackgroundImage(context),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child:
                        _selectedImagePath != null &&
                            _selectedImagePath!.isNotEmpty
                                ?
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.all(
                              Radius.circular(8)),
                          child: CachedNetworkImage(
                            height:180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl:
                            "${Network.imgUrl}${_selectedImagePath}",
                            progressIndicatorBuilder:
                                (context, url,
                                downloadProgress) =>
                                Center(
                                  child: CircularProgressIndicator(
                                      value:
                                      downloadProgress
                                          .progress),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                Image.asset(
                                  "assets/logo/Central icon.png",
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                          ),
                        )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Top + Icon
                                      CircleAvatar(
                                        radius: 18,
                                        child: Image.asset(
                                            "assets/images/add button.png"),
                                      ),
                                      const SizedBox(
                                          height:
                                              20), // Space between icon and text
                                      // Text below the icon
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('background'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
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
                          if(cardName.text.isNotEmpty) {
                            Utility.showLoader(context);
                            submitData(_selectedImage ?? File(""));
                          }else{
                            Utility().showFlushBar(context: context, message: "Please enter card name",isError: true);
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
                                  .translate('continue'),// Right side text
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
      ),
    );
  }

  void _showBottomSheetForBackgroundImage(BuildContext context) {
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
      ListView.separated
        (
          shrinkWrap: true,
          itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            _selectedImagePath = backgroundImageList?[index].filePath ?? "";
            setState(() {

            });
            Navigator.pop(context);
          },
          child: Row(children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.all(
                  Radius.circular(50)),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                imageUrl:
                "${Network.imgUrl}${backgroundImageList?[index].filePath ?? ""}",
                progressIndicatorBuilder:
                    (context, url,
                    downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                          value:
                          downloadProgress
                              .progress),
                    ),
                errorWidget:
                    (context, url, error) =>
                    Image.asset(
                      "assets/logo/Central icon.png",
                      height: 50,
                      fit: BoxFit.fill,
                      width: 50,
                    ),
              ),
            ),
            SizedBox(width: 5,),
            Text(backgroundImageList?[index].name ?? "")
          ],),
        );
      }, separatorBuilder: (context, index) {
        return SizedBox(height: 10,);
      }, itemCount: backgroundImageList?.length ?? 0)
    ]));});}

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Update the dialogPickerColor using the callback.
      color: _currentColor,
      onColorChanged: (Color color) => setState(() => _currentColor = color),
      actionButtons: ColorPickerActionButtons(dialogActionOnlyOkButton: true),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
          AppLocalizations.of(context)
              .translate('selectCardColor'),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
          AppLocalizations.of(context)
              .translate('selectColorShade'),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
          AppLocalizations.of(context)
              .translate('selectedColorAndshades'),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      transitionBuilder: (context, a1, a2, widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  Future<void> submitData(File selectedImage) async {
   //  var file;
   //  Utility.showLoader(context);
   //  if (!selectedImage.path.contains("storage")) {
   //     file = await http.MultipartFile.fromPath(
   //      'backgroung_image',
   //      selectedImage.path,
   //    );
   //  }
   //  Map<String, dynamic> data = {
   //  'step_no' : "4",
   //  'card_style' : _currentColor.hex,
   // 'card_name' : cardName.text.toString(),
   //    'backgroung_image':file.toString()
   //  };
    var data=null;
    // if (selectedImage != null &&
    //     selectedImage!.path != "" &&
    //     !selectedImage!.path.contains("storage")) {
    //   data = FormData.fromMap({
    //    if(_selectedImage != null && _selectedImage!.path.isNotEmpty) 'backgroung_image':
    //     await MultipartFile.fromFile(_selectedImage!.path, filename: "demo.png"),
    //     'step_no' : "4",
    //     'card_style' : _currentColor.hex,
    //     'card_name' : cardName.text.toString(),
    //   });
    // }else{
      data = FormData.fromMap({
        'step_no' : "4",
        'card_style' : _currentColor.hex,
        'card_name' : cardName.text.toString(),
        "is_image":"no",
       if(_selectedImagePath != null && _selectedImagePath!.isNotEmpty) 'backgroung_image':_selectedImagePath
      });
    // }
    _updateCardCubit?.cardUpdateApi(data,widget.cardId,);
  }

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
              _selectedImage = File(pickedFile.path);
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
              _selectedImage = File(pickedFile.path);
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
            .translate('permissionText')),
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
                title:  Text(AppLocalizations.of(context)
                    .translate('useCamera'),),
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
                title:  Text(AppLocalizations.of(context)
                    .translate('chooseFromLibrary'),),
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
                  leading: Icon(Icons.delete_outline, color: Colors.black),
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

  Color _currentColor = Colors.blue; // Initial color

  // Function to get the color code in HEX format
  String getColorCode(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
