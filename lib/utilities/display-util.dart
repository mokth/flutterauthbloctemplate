import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:auto_size_text/auto_size_text.dart';

class DisplayUtil {
  static TextStyle inputTextStyle() {
    return TextStyle(
      fontSize: 14.0,
      color: Colors.blue,
    );
  }

  static Text listHeaderText(String title,
      {TextAlign textAlign: TextAlign.start,
      fontWeight: FontWeight.normal,
      fontSize: 15.0,
      color: Colors.white,
      curScaleFactor: 1.0}) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontSize * curScaleFactor,
          fontWeight: fontWeight,
          color: color),
    );
  }

  static Text listItemText(String title,
      {TextAlign textAlign: TextAlign.start,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      maxline: 1,
      softWrap: false,
      curScaleFactor: 1.0,
      fontSize: 15.0}) {
    return Text(
      title,
      maxLines: maxline,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: GoogleFonts.lato(
          fontSize: fontSize * curScaleFactor,
          fontWeight: fontWeight,
          color: color),
      //TextStyle(fontSize: fontSize * curScaleFactor, fontWeight: fontWeight, color: color),
    );
  }

  static Text listItemTextCondense(String title,
      {TextAlign textAlign: TextAlign.start,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      maxline: 1,
      softWrap: false,
      curScaleFactor: 1.0,
      fontSize: 15.0}) {
    return Text(
      title,
      maxLines: maxline,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: GoogleFonts.robotoCondensed(
          fontSize: fontSize * curScaleFactor,
          fontWeight: fontWeight,
          color: color),
      //TextStyle(fontSize: fontSize * curScaleFactor, fontWeight: fontWeight, color: color),
    );
  }

  static Text entryText(String title,
      {TextAlign textAlign: TextAlign.center,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      curScaleFactor: 1.0,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      fontSize: 15.0}) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: GoogleFonts.lato(
          fontSize: fontSize * curScaleFactor,
          fontWeight: fontWeight,
          color: color),
      // TextStyle(fontSize: fontSize * curScaleFactor,
      //                 fontWeight: fontWeight,
      //                 color: color),
    );
  }

  static Text displayText(String title,
      {TextAlign textAlign: TextAlign.center,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      curScaleFactor: 1.0,
      maxLines: 1,
      fontSize: 15.0}) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: fontSize * curScaleFactor,
          fontWeight: fontWeight,
          color: color),
    );
  }

  static InputDecoration inputDecorationEx(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.lightBlue),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.teal),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.teal),
        ),
        contentPadding: EdgeInsets.fromLTRB(5, 3, 5, 2),
        fillColor: Colors.white);
  }

  static Widget formEditInput(String label, TextEditingController controler,
      {bool enable: true,
      keyboardType: TextInputType.text,
      needValidation: true,
      textAlign: TextAlign.start}) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          child: Text(
            label,
            textAlign: textAlign,
            style: TextStyle(
              color: Colors.blueGrey[900],
              fontSize: 14.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.fromLTRB(0, 15, 0, 3),
          child: TextFormField(
            textAlign: textAlign,
            keyboardType: keyboardType,
            enabled: enable,
            style: DisplayUtil.inputTextStyle(),
            decoration: DisplayUtil.inputDecorationEx(''),
            controller: controler,
            validator: (value) {
              if (needValidation) {
                if (value.isEmpty) {
                  return "*";
                }
              }
              return "";
            },
          ),
        ),
      ],
    );
  }

  static Future<bool> showMessage(
    String message, {
    curScaleFactor: 1,
    color: Colors.white,
    fontSize: 13.0,
    toastLength: 1, // Toast.LENGTH_SHORT,
    backgroundColor: Colors.red,
  }) async {
    bool result = await Fluttertoast.showToast(
        msg: message,
        toastLength:
            (toastLength == 1) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: backgroundColor,
        textColor: color,
        fontSize: fontSize);

    return result;
  }

  static double getcurScaleFactor(BuildContext context) {
    double curScaleFactor = 1;
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).devicePixelRatio);
    double scrwitdh = MediaQuery.of(context)
        .size
        .width; // * MediaQuery.of(context).devicePixelRatio;
    //print(scrwitdh);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (scrwitdh >= 800) {
      curScaleFactor = 1.9;
      if (isLandscape) {
        curScaleFactor = 1.5;
      }
    } else if (scrwitdh >= 600) {
      curScaleFactor = 1.5;
      if (isLandscape) {
        curScaleFactor = 1.3;
      }
    } else if (scrwitdh >= 400) {
      curScaleFactor = 1.2;
    } else
      curScaleFactor = 1;

    return curScaleFactor;
  }

  static showConfirmDialog(BuildContext context, String title, String message,
      double curScaleFactor, double devicePixelRatio, Function func) {
    double fontsize1 = curScaleFactor >= 1.6 ? 15 : 12;
    if (devicePixelRatio > 2) {
      fontsize1 = curScaleFactor >= 1.6 ? 15 : 14;
    }
    var alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: fontsize1),
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            func();
            Navigator.of(context).pop(true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  static Future<void> alertMessage(BuildContext context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                  text: msg,
                  style: TextStyle(fontSize: 16, color: Colors.red[900])),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
