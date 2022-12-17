import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class CustomDialogBox extends StatefulWidget {
   List<Map<String, double>> visitList = [];

  CustomDialogBox(
      { Key? key,  required this.visitList})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          // height: double.infinity,
          margin: const EdgeInsets.only(
              top: Constants.dialogTopMargin,
              right: Constants.dialogLRMargin,
              left: Constants.dialogLRMargin),

          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Constants.dialogBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Current Location",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(height: 20),
              Text(
                "Latitude : ${widget.visitList[0]["latitude"]!.toInt()}",
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: "Roboto"),
              ),
              Text(
                "Longitude : ${widget.visitList[0]["longitude"]!.toInt()}",
                style: const TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: "Roboto"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Previous",
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: "Roboto"),
              ),
              const SizedBox(height: 20),
              ListBody(
                children: buildVisitList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.dialogCloseIconSize),
                color: Constants.dialogCloseIconColor,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: Constants.dialogCloseIconSize,
              ),
            ),
          ),
        )
      ],
    );
  }


  buildVisitList() {
    List<Widget> listWidget = [];
    widget.visitList.forEach((element) {
      listWidget.add(Text(
        "Lat: ${element["latitude"]?.toInt()}, Long: ${element["longitude"]?.toInt()}",
        textAlign: TextAlign.center,
        style:
        TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Roboto"),
      ));
    });
    return listWidget;
  }
}
