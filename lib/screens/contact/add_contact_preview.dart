import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../data/repository/contact_repository.dart';
import '../../models/contact_details_dto.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';

class AddContactPreview extends StatefulWidget {
  final String contactId;
  const AddContactPreview({super.key, required this.contactId});

  @override
  State<AddContactPreview> createState() => _AddContactPreviewState();
}

class _AddContactPreviewState extends State<AddContactPreview> {
  ContactCubit? _contactDetailCubit;
  bool isLoad = true;
  DataContact? contactDetailsDatum;


  @override
  void initState() {
    _contactDetailCubit = ContactCubit(ContactRepository());
    getContactDetail();
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _contactDetailCubit?.close();
    _contactDetailCubit = null;
  }

  Future<void> getContactDetail() async {
    _contactDetailCubit?.apiGetContactDetail(widget.contactId);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: _contactDetailCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              isLoad = false;
              var dto = state.data as ContactDetailsDto;
              contactDetailsDatum = dto.data;
              // setLink();
            }
            setState(() {});
          },
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
        decoration: BoxDecoration(
            color:  contactDetailsDatum
            ?.cardStyle !=
        null
        ? Color(int.parse(
        '0xFF${contactDetailsDatum!.cardStyle!}'))
            : ColoursUtils.whiteLightColor.withOpacity(1.0),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
        child: Column(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(44),
              color: Colors.white),
              child:Image.asset("assets/images/close.png")
            ),
            Text(
              contactDetailsDatum?.cardName ?? "",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(44),
                    color: Colors.white),
                child:Icon(Icons.add)
            )
          ],
        ),
      ),
    );
  }
}
