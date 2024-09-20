import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';

class CustomInfomationLeadWidget extends StatelessWidget {
  const CustomInfomationLeadWidget({super.key, this.name, this.type, this.avatarUrl});
  final String? name;
  final String? type;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    print(name);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.minPadding!, vertical: AppSizes.minPadding!/2),
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAvatarWithURL(
                    backgroundColor: Color(0xFFEEB132),
                    url: avatarUrl ?? "",
                    name: name,
                    size: 30.0,
                  ),
          SizedBox(width: 4.0,),
          Expanded(
            child: Text(
              name ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              // maxLines: 1,
            ),
          ),
          Text(
            type ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.end,
            style: TextStyle(
                color: AppColors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500),
            // maxLines: 1,
          )
        ],
      ),
    );
  }
}