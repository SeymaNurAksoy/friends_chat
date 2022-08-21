import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget{

  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final double? radius;
  final double? height;
  final Widget? buttonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton(
      {Key? key,
     /*required*/this.buttonText,
     this.buttonColor,
     this.textColor,
     this.radius,
     this.height : 40,
     this.buttonIcon,
     required this.onPressed}) :
        //assert(buttonText != null)
  assert(onPressed !=null),
        super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: SizedBox(
        height: height,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
          ),
          child:  Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              /*if(buttonIcon !=null) ...[
                buttonIcon!,
                Text(buttonText!,style: TextStyle(color: textColor),
                ),
                Opacity(opacity: 0,child: buttonIcon)
              ],
              if(buttonIcon ==null) ...[
                Container(),
                Text(buttonText!,style: TextStyle(color: textColor),
                ),
                Container()
              ],*/
              buttonIcon ?? Container(),
              Text(buttonText!,style: TextStyle(color: textColor),
              ),
              Opacity(opacity: 0,child: buttonIcon)
            ],
          ),
          color:buttonColor,
          onPressed: onPressed, ),
      ),
    );
  }

}