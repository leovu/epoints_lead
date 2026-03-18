part of widget;

class CustomImageList extends StatelessWidget {
  final List<CustomImageListModel>? models;
  final bool enableAdd;
  final Function(List<File>)? onAdd;
  final Function(int)? onRemove;
  final Function(File)? onSingleAdd;
  final String? hintText;
  final int? limit;
  final bool? isRequired;
  final String? errorMessage;

  CustomImageList(
      {this.models,
      this.enableAdd = true,
      this.onAdd,
      this.onRemove,
      Key? key,
      this.onSingleAdd,
      this.hintText,
      this.limit,
      this.errorMessage,
      this.isRequired})
      : super(key: key);

  Widget _buildAdd(BuildContext context) {
    return Column(
      children: [
        if (hintText != null) ...[
          CustomText(
            text: hintText,
            color: AppColors.grey34,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: AppSizes.minPadding,
          )
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: enableAdd
                    ? () {
                        if (onAdd != null) {
                          CustomImagePicker.showPicker(context, (files) {
                            if (limit != null) {
                              if (((models?.length ?? 0)) > limit!) {
                                CustomNavigator.showCustomAlertDialog(
                                    context,
                                    "Thông báo",
                                    "Chỉ được chọn tối đa $limit ảnh");
                              } else {
                                onAdd!([files]);
                              }
                            } else {
                              onAdd!([files]);
                            }
                          });
                        } else {
                          CustomImagePicker.showPicker(context, onSingleAdd!);
                        }
                      }
                    : null,
                child: Container(
                  height: 40,
                  width: AppSizes.maxWidth! - 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey500Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                      child: Text(
                    "Nhấn để tải hình ảnh lên",
                    style: TextStyle(
                        color: AppColors.grey500Color,
                        fontSize: AppTextSizes.size14),
                  )),
                ))
          ],
        )
      ],
    );
  }

  Widget _buildSkeleton() {
    return CustomSkeleton();
  }

  @override
  Widget build(BuildContext context) {
    double removeSize = 18.0;
    double width = getWidthOfItemPerRow(context, 4);
    if (width > 90) {
      width = 90;
    }

    if (onRemove != null) {
      width = width - removeSize / 2;
    }

    if (models == null) {
      return _buildSkeleton();
    }

    List<Widget> children = List.generate(models?.length ?? 0, (index) {
      String? url = models![index].url;
      File? file = models![index].file;

      return InkWell(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: onRemove == null
                  ? null
                  : EdgeInsets.only(top: removeSize / 2, right: removeSize / 2),
              child: file == null
                  ? CustomNetworkImage(width: width, height: width, url: url)
                  : Image.file(
                      file,
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                    ),
            ),
            if (onRemove != null)
              GestureDetector(
                child: CustomImageIcon(
                  icon: Assets.iconCloseCircle,
                  size: removeSize,
                ),
                onTap: () => onRemove!(index),
              ),
          ],
        ),
      );
    }).toList();

    return CustomColumnWidget(
        errorMessage: errorMessage,
        isRequired: isRequired,
        title:
            "${AppLocalizations.text(LangKey.image)}${limit == null ? "" : " (${models?.length ?? 0}/$limit)"} ",
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: AppSizes.minPadding,
                runSpacing: AppSizes.minPadding,
                children: children,
              ),
            ),
            if (onAdd != null || onSingleAdd != null)
              if (limit == null)
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.minPadding),
                  child: _buildAdd(context),
                )
              else if ((models?.length ?? 0) < limit!)
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.minPadding),
                  child: _buildAdd(context),
                ),
          ],
        ));
  }
}

class CustomImageListModel {
  String? url;
  File? file;
  String? note;
  DateTime? createdAt;

  CustomImageListModel({this.url, this.file, this.note, this.createdAt});
}
