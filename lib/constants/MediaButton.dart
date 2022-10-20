import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'color_constans.dart';

class MediaButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final String? icon;
  final Color? color;
  final Color? textColor;
  const MediaButton(
      {super.key, required this.onPressed,
      required this.title,
      this.icon,
      this.color,
      this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width / 1.2,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),

      // ignore: deprecated_member_use
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        onPressed: onPressed,
        elevation: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15, child: Image.asset(icon!)),
            const SizedBox(
              width: 3,
            ),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customButton (
     Function() onPressed,
         context,
     String title, {
       double? height = 50,
       double? width = 200,
      Color? color = customColor,
      Color? textColor=Colors.white}) {

  return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      // ignore: deprecated_member_use
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: customButtonColor,
        onPressed: onPressed,
        elevation: 3,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: textColor!,
          ),
        ),
      ),
    );
  }
