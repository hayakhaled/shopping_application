import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class Badge extends StatelessWidget{
  final Widget child;
  final String value;
  final Color color;

  const Badge({
  @required this.child,
  @required this.value,
  @required this.color
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
         right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color:color !=null ? color : Color(0xff7C7B7C),
            ),
            constraints:BoxConstraints(
              minWidth: 16
                  ,minHeight: 16
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style:TextStyle(fontSize:15),
            ),
          ),
        )
      ],
    );
  }
}