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


class ChangePassword extends StatefulWidget {
  int? isStudent;

  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasController = TextEditingController();
  final TextEditingController _confirmPasController = TextEditingController();
  AuthCubit? settingCubit;

  @override
  void initState() {
    settingCubit = AuthCubit(AuthRepository());
    super.initState();
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  bool validatePasswordRegx(String password) {
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$';
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  String? email, password;
  bool isPassword = true;
  bool isPasswordNew = true;
  bool isPasswordConfirm = true;
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
              Utility().showFlushBar(context: context, message: dto.message ?? "");
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
            AppLocalizations.of(context).translate('changePassword'),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                obscureText: isPassword,
                validator: validatePassword,
                controller: _currentPasswordController,
                onSaved: (value) => password = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('currentPassword'),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  alignLabelWithHint: true,
                  fillColor: ColoursUtils.background,
                  hintStyle: TextStyle(
                      color: ColoursUtils.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/lock-02.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/eye-off.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: isPasswordNew,
                validator: validatePassword,
                controller: _newPasController,
                onSaved: (value) => password = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('newPassword'),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  alignLabelWithHint: true,
                  fillColor: ColoursUtils.background,
                  hintStyle: TextStyle(
                      color: ColoursUtils.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/lock-02.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordNew = !isPasswordNew;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/eye-off.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: isPasswordConfirm,
                validator: validatePassword,
                controller: _confirmPasController,
                onSaved: (value) => password = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate("confirmPassword"),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  alignLabelWithHint: true,
                  fillColor: ColoursUtils.background,
                  hintStyle: TextStyle(
                      color: ColoursUtils.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/lock-02.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordConfirm = !isPasswordConfirm;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/eye-off.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
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
                      if (validatePasswordRegx(_newPasController.text)) {
                        if(validatePasswordRegx(_confirmPasController.text)) {
                          if(_newPasController.text == _confirmPasController.text) {
                            Utility.hideKeyboard(context);
                            Utility.showLoader(context);
                            apiChangePassword();
                          }else{
                            Utility().showFlushBar(context: context, message:"New Password and Confirm Password are not same",isError: true);
                          }
                        }else{
                          Utility().showFlushBar(context: context, message:"Confirm Password is invalid. It must include uppercase, lowercase, digits, and special characters.",isError: true);
                        }
                      }else{
                        Utility().showFlushBar(context: context, message:"New Password is invalid. It must include uppercase, lowercase, digits, and special characters.",isError: true);
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

  apiChangePassword() {
    String currentPass = _currentPasswordController.text.trim();
    String newPass = _newPasController.text.trim();


    Map<String, dynamic> data = {
      "current_password": currentPass,
      "new_password": newPass,
    };
    settingCubit?.apiChangePassword(data);
  }

}
