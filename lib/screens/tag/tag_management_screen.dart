import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/contact/contact_notes.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../language/app_localizations.dart';
import '../../models/tag_model.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';

class TagManagementScreen extends StatefulWidget {
  bool? isFromCard;
   TagManagementScreen({super.key,this.isFromCard});

  @override
  _TagManagementScreenState createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  GroupCubit? _getTagCubit, addTagCubit, deleteTag, _updateTag;
  ContactCubit?getCardTagCubit,addCardTagCubit,deleteCardTag,updateCardTag;

  List<TagDatum> tags = [];
  int selectedIndex = 0;
  bool isLoad = true;

  @override
  void initState() {
    getCardTagCubit = ContactCubit(ContactRepository());
    addCardTagCubit = ContactCubit(ContactRepository());
    deleteCardTag = ContactCubit(ContactRepository());
    updateCardTag = ContactCubit(ContactRepository());
    _getTagCubit = GroupCubit(GroupRepository());
    deleteTag = GroupCubit(GroupRepository());
    _updateTag = GroupCubit(GroupRepository());
    addTagCubit = GroupCubit(GroupRepository());
    if(widget.isFromCard == false){
    apiTagList("");}else {
      apiGetCardTag("");
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _getTagCubit?.close();
    deleteTag?.close();
    addTagCubit?.close();
    _updateTag?.close();
    _getTagCubit = null;
    _updateTag = null;
    deleteTag = null;
    addTagCubit = null;
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> apiTagList(keyword) async {
    // Utility.showLoader(context);
    Map<String, dynamic> data = {
      "key_word": keyword.toString(),
      "page": 1,
    };
    _getTagCubit?.apiGetTeamTag(data);
  }


Future<void> apiGetCardTag(keyword) async {
  Map<String, dynamic> data = {
      "key_word": keyword.toString(),
      "page": 1,
    };
    getCardTagCubit?.apiGetCardTag(data);
  }

  Future<void> apiAddTag(tagName) async {
    Map<String, dynamic> data = {
      "tag": tagName,
    };
    addTagCubit?.apiAddTag(data);
  }

  Future<void> apAddCardTag(tagName) async {
    Map<String, dynamic> data = {
      "tag": tagName,
    };
    addCardTagCubit?.apiAddCardTag(data);
  }

  Future<void> apiUpdateTag({tagName, id}) async {
    Map<String, dynamic> data = {
      "tag": tagName,
    };
    _updateTag?.apiUpdateTag(data, id);
  }

  Future<void> apiUpdateCardTag({tagName, id}) async {
    Map<String, dynamic> data = {
      "tag": tagName,
    };
    updateCardTag?.apiUpdateCardTag(data, id);
  }

  Future<void> apiDeleteTag({id}) async {
    deleteTag?.apiDeleteTag(id);
  }

  Future<void> apiDeleteCardTag({id}) async {
    deleteCardTag?.apiDeleteCardTag(id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GroupCubit, ResponseState>(
          bloc: _getTagCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
            } else if (state is ResponseStateError) {
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as TagModel;
              tags = dto.data?.data ?? [];
              isLoad = false;
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: getCardTagCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
            } else if (state is ResponseStateError) {
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as TagModel;
              tags = dto.data?.data ?? [];
              isLoad = false;
            }
            setState(() {});
          },
        ),
        BlocListener<GroupCubit, ResponseState>(
          bloc: deleteTag,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
              tags.removeAt(selectedIndex);
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: deleteCardTag,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
              tags.removeAt(selectedIndex);
            }
            setState(() {});
          },
        ),
        BlocListener<GroupCubit, ResponseState>(
          bloc: addTagCubit,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              if(widget.isFromCard == false){
                apiTagList("");}else {
                apiGetCardTag("");
              }
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: addCardTagCubit,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              if(widget.isFromCard == false){
                apiTagList("");}else {
                apiGetCardTag("");
              }
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
            }
            setState(() {});
          },
        ),
        BlocListener<GroupCubit, ResponseState>(
          bloc: _updateTag,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
              apiTagList("");

            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: updateCardTag,
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
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              Utility().showFlushBar(
                context: context,
                message: dto.message ?? "",
              );
              apiGetCardTag("");

            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColoursUtils.background,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: Text(
              AppLocalizations.of(context).translate('tagsManagement'),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: Constants.fontFamily),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10, top: 6),
              padding: const EdgeInsets.only(right: 0, top: 6, bottom: 6),
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.blue, // Splash color
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.sizeOf(context).height / 1.5,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 13),
                  child: Text(
                      AppLocalizations.of(context).translate('existingTags'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                isLoad ? _getShimmerView():
             tags.isNotEmpty && isLoad == false ?   Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width -70,minWidth: 30),
                              padding: const EdgeInsets.all(
                                  10), // Add padding inside the container

                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                // Light background color
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Text(
                                tags[index].tag ?? "",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black, // Text color
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                switch (value) {
                                  case 'Edit':
                                    editNottomSheet(context,index);
                                    break;
                                  case 'Delete':
                                    _deleteTag(index,context);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      // ListTile(
                      //   title:
                      //   // Text(tags[index]),
                      //   trailing:
                      // );
                    },
                  ),
                ):
               Expanded(child: Center(child: Text( AppLocalizations.of(context).translate('noTagFound'),)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getShimmerView() {
    return Shimmer.fromColors(
        baseColor: Color(0x72231532),
        highlightColor: Color(0xFF463B5C), child:  ListView.separated(
      shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            color: Colors.grey.withOpacity(0.7),
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              margin:
              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,height: 30,
                    padding: const EdgeInsets.all(
                        10), // Add padding inside the container

                    decoration: BoxDecoration(
                      color:  Color(0x72231532),
                      // Light background color
                      borderRadius:
                      BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  Container(height: 30,width: 30,decoration: BoxDecoration(color:  Color(0x72231532),borderRadius: BorderRadius.circular(30)),)
                ],
              ),
            );
          },
        ));
  }
  void _showBottomSheet(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: 200,maxHeight: MediaQuery.of(context).size.height-200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:  EdgeInsets.only(right: 16.0,left: 16,top: 16,bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add Tag Input Field
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                  AppLocalizations.of(context).translate('addTag1'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 25,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if(controller.text.isNotEmpty) {
                          Navigator.pop(context);
                          if(widget.isFromCard == false) {
                            Utility.showLoader(context);
                            apiAddTag(controller.text);
                          }else{
                            Utility.showLoader(context);
                            apAddCardTag(controller.text);
                          }
                        }
                        controller.clear();
                      },
                      child:  Text(
                           AppLocalizations.of(context).translate('save'),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_rounded))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light white color
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  onTapOutside: (v){
                    Utility.hideKeyboard(context);
                  },
                  onChanged: (v) {
                    setState(() {});
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Add Tag',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // const SizedBox(height: 16),
              // const Text(
              //   "Add Contacts",
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 10),
              // // Search Input Field
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200], // Light white color
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: const Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           decoration: InputDecoration(
              //             hintText: 'Search...',
              //             border: InputBorder.none,
              //             hintStyle: TextStyle(color: Colors.grey),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const Spacer(),
              // // Contact Information
              // ListTile(
              //   contentPadding: const EdgeInsets.only(right: 0),
              //   leading: const CircleAvatar(
              //     radius: 30,
              //     backgroundImage: AssetImage("assets/images/user_dummy.png"),
              //   ),
              //   title: const Text(
              //     "Janice Schneider",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 16,
              //         color: Colors.black),
              //   ),
              //   subtitle: const Text("Sr. Product Solutions Manager"),
              //   trailing: Container(
              //     child: ClipOval(
              //       child: Material(
              //         color: Colors.blue, // Button color
              //         child: InkWell(
              //           splashColor: Colors.blue, // Splash color
              //           onTap: () {
              //             // Navigator.push(
              //             //     context,
              //             //     CupertinoPageRoute(
              //             //         builder: (builder) => AddContactNotes()));
              //           },
              //           child: const SizedBox(
              //               width: 40,
              //               height: 40,
              //               child: Icon(
              //                 Icons.add,
              //                 color: Colors.white,
              //               )),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

            ],
          ),
        );
      },
    );
  }
  void editNottomSheet(BuildContext context,index) {
    TextEditingController controller =
    TextEditingController(text: tags[index].tag);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: 200,maxHeight: MediaQuery.of(context).size.height-200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:  EdgeInsets.only(right: 16.0,left: 16,top: 16,bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add Tag Input Field
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                  AppLocalizations.of(context).translate('editTag1'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  // SizedBox(w: 10,),
                  Spacer(),
                  SizedBox(
                    height: 25,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        elevation: 0,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if(controller.text.isNotEmpty){
                        setState(() {
                          selectedIndex = 0;
                        });
                        Navigator.pop(context);
                        if(widget.isFromCard == false) {
                          Utility.showLoader(context);
                          apiUpdateTag(
                              tagName: controller.text, id: tags[index].id.toString());
                        }else{
                          Utility.showLoader(context);
                          apiUpdateCardTag(
                              tagName: controller.text, id: tags[index].id.toString());
                        }
                        controller.clear();}
                      },
                      child:  Text(
        AppLocalizations.of(context).translate('save'),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_rounded))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light white color
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  onTapOutside: (v){
                    Utility.hideKeyboard(context);
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onChanged: (v) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Edit Tag',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // const SizedBox(height: 16),
              // const Text(
              //   "Add Contacts",
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500),
              // ),
              // const SizedBox(height: 10),
              // // Search Input Field
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200], // Light white color
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: const Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           decoration: InputDecoration(
              //             hintText: 'Search...',
              //             border: InputBorder.none,
              //             hintStyle: TextStyle(color: Colors.grey),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const Spacer(),
              // // Contact Information
              // ListTile(
              //   contentPadding: const EdgeInsets.only(right: 0),
              //   leading: const CircleAvatar(
              //     radius: 30,
              //     backgroundImage: AssetImage("assets/images/user_dummy.png"),
              //   ),
              //   title: const Text(
              //     "Janice Schneider",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 16,
              //         color: Colors.black),
              //   ),
              //   subtitle: const Text("Sr. Product Solutions Manager"),
              //   trailing: Container(
              //     child: ClipOval(
              //       child: Material(
              //         color: Colors.blue, // Button color
              //         child: InkWell(
              //           splashColor: Colors.blue, // Splash color
              //           onTap: () {
              //             // Navigator.push(
              //             //     context,
              //             //     CupertinoPageRoute(
              //             //         builder: (builder) => AddContactNotes()));
              //           },
              //           child: const SizedBox(
              //               width: 40,
              //               height: 40,
              //               child: Icon(
              //                 Icons.add,
              //                 color: Colors.white,
              //               )),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

            ],
          ),
        );
      },
    );
  }

  // Function to handle editing a tag
  void _editTag(int index) {
    TextEditingController controller =
        TextEditingController(text: tags[index].tag);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text( AppLocalizations.of(context).translate('editTag1'),),
        content: TextField(
          controller: controller,
          decoration:  InputDecoration(hintText:AppLocalizations.of(context).translate('hintTageName'),),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
              Navigator.pop(context);
              if(widget.isFromCard == false) {
                apiUpdateTag(
                    tagName: controller.text, id: tags[index].id.toString());
              }else{
                apiUpdateCardTag(
                    tagName: controller.text, id: tags[index].id.toString());
              }
            },
            child:  Text( AppLocalizations.of(context).translate('save'),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text( AppLocalizations.of(context).translate('cancel'),),
          ),
        ],
      ),
    );
  }

  // Function to handle deleting a tag
  void _deleteTag(int index,context) {
    setState(() {
      selectedIndex = index;
      if(widget.isFromCard == false) {
        Utility.showLoader(context);
        apiDeleteTag(id: tags[index].id.toString());
      }else{
        Utility.showLoader(context);
        apiDeleteCardTag(id: tags[index].id.toString());
      }
    });
  }
}
