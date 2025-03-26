import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/models/utility_dto.dart';

import '../../bloc/api_resp_state.dart';
import '../../models/my_contact_model.dart';
import '../../models/tag_model.dart';
import '../../utils/utility.dart';

class AddTagInContactBottomSheet extends StatefulWidget {
  List<TagDatum> tags;
  final int contactId;
  List<ContactTag> contactTags;

  AddTagInContactBottomSheet(
      {super.key, required this.tags, required this.contactId,required this.contactTags});

  @override
  State<AddTagInContactBottomSheet> createState() =>
      _AddTagInContactBottomSheetState();
}

class _AddTagInContactBottomSheetState
    extends State<AddTagInContactBottomSheet> {
  ContactCubit? contactCubit;

  @override
  void initState() {
    contactCubit = ContactCubit(ContactRepository());
    widget.contactTags.forEach((element) {
      widget.tags.forEach((element1) {
        if(element.contactTagId == element1.id){
            element1.isCheck = true;
        }
      },);
    },);
    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> apiAddTag() async {
    List<int> tagId = [];
    widget.tags.forEach(
      (element) {
        if (element.isCheck == true) {
          tagId.add(element.id ?? 0);
        }
      },
    );
    String contactTagIdsString = tagId.join(',');
    Map<String, dynamic> data = {
      "contact_id": widget.contactId.toString(),
      "contact_tag_ids": contactTagIdsString,
    };
    contactCubit?.apiAddTagInContact(data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: contactCubit,
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
              Utility()
                  .showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },
        ),
      ],
      child: Container(
        // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 100,minHeight: 20),
        padding: EdgeInsets.only(bottom: 30,top: 16,left: 16,right: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
                Text("Tags",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
                SizedBox(
                  height: 40,
                  width:  widget.contactTags.isNotEmpty ?105:85,
                  child: ElevatedButton(
                    // iconAlignment: IconAlignment.start,
                    onPressed: () {
                      Utility.showLoader(context);
                      apiAddTag();
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
                          widget.contactTags.isNotEmpty ?"Update":"Add", // Right side text
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 36,),
            ListView.separated(
              shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.tags[index].tag ?? ""),
                      Container(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: widget.tags[index].isCheck ?? false,
                          onChanged: (value) {
                            widget.tags[index].isCheck =
                                widget.tags[index].isCheck == true ? false : true;
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 16,
                  );
                },
                itemCount: widget.tags.length),
          ],
        ),
      ),
    );
  }
}
