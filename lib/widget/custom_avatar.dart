import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CustomAvatar extends StatelessWidget {

  final String name;
  final double textSize;
  final Color color;

  CustomAvatar({
    @required this.name, this.textSize, this.color
  }):assert(name != null);

  String getFirstChar(String event){
    if(event.length == 0)
      return "";
    return event.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) {

    String newName;
    List<String> models = name.split(" ");

    if(models != null && models.length > 1)
      newName = getFirstChar(models[0]) + getFirstChar(models[models.length - 1]);
    else
      newName = getFirstChar(name);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color == null ?  AppColors.primaryColor : color),
      child: Center(
        child: Text(
          newName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: textSize??20.0
          ),
        ),
      ),
    );
  }
}