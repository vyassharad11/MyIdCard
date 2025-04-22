import 'package:flutter/material.dart';

class AddContactPreview extends StatefulWidget {
  const AddContactPreview({super.key});

  @override
  State<AddContactPreview> createState() => _AddContactPreviewState();
}

class _AddContactPreviewState extends State<AddContactPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
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
            // "${contactDetailsDatum?.cardName ?? ""}",
            "",
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
    );
  }
}
