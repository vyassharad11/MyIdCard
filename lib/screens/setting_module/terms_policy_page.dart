import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/auth_cubit.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';

import '../../bloc/api_resp_state.dart';
import '../../utils/utility.dart';

class TermsPolicyPage extends StatefulWidget {
  String title;
   TermsPolicyPage({super.key,required this.title});

  @override
  State<TermsPolicyPage> createState() => _TermsPolicyPageState();
}

class _TermsPolicyPageState extends State<TermsPolicyPage> {
 AuthCubit? _termsPolicyCubit;
  @override
  void initState() {
    _termsPolicyCubit = AuthCubit(AuthRepository());
    apiGetTermsAndPolicy();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _termsPolicyCubit = null;
    _termsPolicyCubit?.close();
    // TODO: implement dispose
    super.dispose();
  }

  apiGetTermsAndPolicy(){
    if(widget.title == "Privacy Policy"){
      _termsPolicyCubit?.apiGetPrivacy();
    }else {
      _termsPolicyCubit?.apiGetTerms();
    }
  }



  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthCubit, ResponseState>(
      bloc: _termsPolicyCubit,
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
          // var dto = state.data as ContactDetailsDto;
        }
        setState(() {});
      },
      child: Scaffold(

        body: _getBody(),
      ),
    );
  }

  Widget _getBody(){
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top +20,right: 16,left: 16,bottom: 20),
      child: Column(
        children: [
          Row(children: [
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,size: 24),),
            Text(widget.title),
          ],),
          Divider(height: 1,),
          SizedBox(height: 20,),

          Expanded(
            child: SingleChildScrollView(
              child: Text("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
                  "1914 translation by H. Rackham"
              
                  "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical ex"),
            ),
          )

        ],
      ),
    );
  }
}
