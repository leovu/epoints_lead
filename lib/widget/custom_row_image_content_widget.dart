import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/theme.dart';

class CustomRowImageContentWidget extends StatelessWidget {
  const CustomRowImageContentWidget({super.key,  this.icon, this.title,this.child, this.iconColor});
  final String? icon;
  final String? title;
  final Widget? child;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 13.0),
      margin: EdgeInsets.only(left: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(icon ?? Assets.iconAddress, color:iconColor ,),
          ),
          Expanded(
            child: child ?? Text(
              title ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}