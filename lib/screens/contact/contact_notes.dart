import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/card_cubit.dart';
import '../../data/repository/card_repository.dart';
import '../../data/repository/card_repository.dart';
import '../../models/company_type_model.dart';
import '../../utils/utility.dart';
import '../meetings/metting_details.dart';
import '../meetings/metting_list.dart';

class AddContactNotes extends StatefulWidget {
  const AddContactNotes({super.key});

  @override
  State<AddContactNotes> createState() => _AddContactNotesState();
}

class _AddContactNotesState extends State<AddContactNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Abhishek Joshi’s Card",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor:
                      Colors.transparent, // To make corners rounded
                  builder: (context) => FullScreenBottomSheet(),
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50], // Light red background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(color: Colors.red, width: 1), // Red border
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'User deleted his card.',
                      style: TextStyle(
                        color: Colors.black, // Darker red text color
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Text(
                "Notes",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light background color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: const Center(
                  child: Text(
                    "Two driven jocks help fax my big quiz. Quick, Baz, get my woven flax jodhpurs! Now fax quiz Jack!",
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Mettings',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 6),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue, // Button color
                                child: InkWell(
                                  splashColor: Colors.blue, // Splash color
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      // To make corners rounded
                                      builder: (context) =>
                                          FullScreenBottomSheet(),
                                    );
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (ctx, index) {
                            return Container(
                              color: Colors.black12,
                              height: 1,
                            );
                          },
                          itemCount: meetings.length,
                          itemBuilder: (context, index) {
                            final meeting = meetings[index];
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (builder) =>
                                        MeetingDetailsScreen(),
                                  ),
                                );
                              },
                              title: Text(
                                meeting['title'] ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(meeting['description'] ?? ''),
                              trailing: Text(
                                meeting['date'] ?? '',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 14),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (builder) => MeetingsScreen(
                                contactId: 0,
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View All meetings",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 24,
                            )
                          ],
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
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> meetings = [
    {
      'title': 'Meeting with Janice',
      'date': '5 July 2024',
      'description': 'Product Design Discussion',
    },
    {
      'title': 'Meeting with Ori',
      'date': '3 July 2024',
      'description': 'Design System',
    },
    {
      'title': 'Meeting with Max',
      'date': '3 July 2024',
      'description': 'Design System',
    },
    {
      'title': 'Meeting with Max',
      'date': '2 July 2024',
      'description': 'Design System',
    },
  ];
}

class FullScreenBottomSheet extends StatefulWidget {
  bool? isHowPhysical;
  bool? isHide;
  String? companyTypeId,companyName,selectedValue;
  Function(bool ishide, String companyTypeId, String companyName,bool isPhysic,String selectedValue)? callBack;

  FullScreenBottomSheet({super.key, this.callBack,this.isHide,this.companyName,this.companyTypeId,this.isHowPhysical,this.selectedValue});

  @override
  State<FullScreenBottomSheet> createState() => _FullScreenBottomSheetState();
}

class _FullScreenBottomSheetState extends State<FullScreenBottomSheet> {
  CardCubit? _getGetCompanyTypeCubit;
  bool isCheck = false;
  bool isHowPhysical = false;
  String companyId = "";
  String selectedValue = "";
  List<DataCompany> companyList = []; // List to hold parsed data
  TextEditingController companyNameController = TextEditingController();

  @override
  void initState() {
    _getGetCompanyTypeCubit = CardCubit(CardRepository());
    seData();
    fetchData();
    // TODO: implement initState
    super.initState();
  }

  seData(){
    print("selectedValue${widget.selectedValue}");
    companyId = widget.companyTypeId ?? "";
    selectedValue = widget.selectedValue ?? "";
    companyNameController.text = widget.companyName ?? "";
    isCheck = widget.isHide ?? false;
    isHowPhysical = widget.isHowPhysical ?? false;
    setState(() {

    });
  }

  CompanyTypeModel? companyTypeModel;

  Future<void> fetchData() async {
    _getGetCompanyTypeCubit?.apiGetCompanyType();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardCubit, ResponseState>(
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
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        // Adjust this value to control initial height
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Top bar with close icon
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context); // Close the bottom sheet
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 18),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Company dropdown
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        // Type of Company dropdown
                        CustomDropdown(
                          title: 'Type of Company',
                          selectedValue: selectedValue,
                          callBack: (v,value) {
                            companyId = v;
                            selectedValue = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        // Function dropdown
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: companyNameController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              labelText: 'Enter job title',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Show Hidden Contact"),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: isCheck ?? false,
                                onChanged: (value) {
                                  isCheck = !isCheck;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ), const SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Show Physical Contact"),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: isHowPhysical ?? false,
                                onChanged: (value) {
                                  isHowPhysical = !isHowPhysical;
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Outlined Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            widget.callBack?.call(false, "", "",false,"");
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                                color: Colors.black38), // Border color
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Space between buttons
                      // Filled Button (ElevatedButton)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.callBack?.call(
                                isCheck, companyId, companyNameController.text,isHowPhysical,selectedValue);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blueAccent, // Background color
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String title;
   String? selectedValue;
  Function(String id,String value)? callBack;
  List<DataCompany>? companyList; // List to hold parsed data

  CustomDropdown(
      {super.key, required this.title, this.companyList, this.callBack,this.selectedValue});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  initState(){
    if(widget.selectedValue != null && widget.selectedValue!.isNotEmpty){
      _selectedValue = widget.selectedValue ?? "";
    }
    super.initState();
  }

  String? _selectedValue;
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
        color: Colors.grey[50], // Light background color
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(widget.title),
          value: _selectedValue,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue;
              if (newValue.toString() == "IT") {
                _selectedId = "1";
              } else {
                _selectedId = "2";
              }
            });
            widget.callBack?.call(_selectedId ?? "",_selectedValue ?? "");
          },
          items: ['IT', 'Finance'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
