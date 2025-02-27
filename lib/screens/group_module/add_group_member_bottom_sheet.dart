import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/group_repository.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../models/group_member_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';

class AddGroupMemberBottomSheet extends StatefulWidget {
  final String? groupId;
  const AddGroupMemberBottomSheet({super.key,this.groupId});

  @override
  State<AddGroupMemberBottomSheet> createState() => _AddGroupMemberBottomSheetState();
}

class _AddGroupMemberBottomSheetState extends State<AddGroupMemberBottomSheet> {
  GroupCubit? _addGroupMemberCubit ,_getActiveMember;
  List<MemberDatum> groupMember = [];
  int selectedIndex = 0;


  @override
  void initState() {
    _addGroupMemberCubit = GroupCubit(GroupRepository());
    _getActiveMember = GroupCubit(GroupRepository());
    apiGetActiveMemberForGroup("");
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _addGroupMemberCubit?.close();
    _getActiveMember?.close();
    _addGroupMemberCubit = null;
    _getActiveMember = null;
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> apiGetActiveMemberForGroup(key) async {
    Map<String, dynamic> data = {
      "key_word": key,
      "page": 1,
    };
    Utility.showLoader(context);
    _getActiveMember?.apiGetActiveMemberForGroup(data);
  }

  Future<void> apiAddGroupMember(userId) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
        "user_id":userId,
        "group_id":widget.groupId ?? ""
    };
    _addGroupMemberCubit?.apiAddGroupMember(data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<GroupCubit, ResponseState>(
            bloc: _getActiveMember,
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
                var dto = state.data as GroupMember;
                groupMember.clear();
                groupMember.addAll(dto.data?.data ?? []);
              }
              setState(() {});
            },
          ),
          BlocListener<GroupCubit, ResponseState>(
            bloc: _addGroupMemberCubit,
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
                var dto = state.data as UtilityDto;
                Utility().showFlushBar(context: context, message: dto.message ?? "");
                Utility.hideLoader(context);
                groupMember.removeAt(selectedIndex);
              }
              setState(() {});
            },
          ),
        ],
        child: _getBody());
  }

  Widget _getBody(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24,),
            Text("Add Members",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500 ),),
            SizedBox(height: 16,),
            if(groupMember.isNotEmpty)  TextField(
              onChanged: (v){
                apiGetActiveMemberForGroup(v);
              },
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: ColoursUtils.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
           if(groupMember.isNotEmpty) ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circle Image
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(groupMember[index].avatar ?? ""),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 16),

                    // Title and Description Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupMember[index].firstName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            groupMember[index].lastName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Add Icon
                    InkWell(
                      onTap: (){
                        apiAddGroupMember(groupMember[index].id.toString());
                      },
                      child: Image.asset(
                        "assets/images/add_icon.png",
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ],
                ),
              );
            }, separatorBuilder: (context, index) {
              return SizedBox(height: 12,);
            }, itemCount: groupMember.length),
            if(groupMember.isEmpty) SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Text("No record found")))
          ],
        ),
      ),
    );
  }

}
