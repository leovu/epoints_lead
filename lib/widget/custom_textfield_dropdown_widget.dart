part of widget;

class CustomTextfieldDropdownWidget extends StatelessWidget {
  final String? title;
  final String? icon;
  final String? content;
  final bool? mandatory;
  final bool? dropdown;
  final bool? textfield;
  final TextInputType? inputType;
  final TextEditingController? fillText;
  final FocusNode? focusNode;
  final Function()? ontap;

  CustomTextfieldDropdownWidget(
      {super.key,
      this.title,
      this.icon,
      this.content,
      this.mandatory,
      this.dropdown,
      this.textfield = true,
      this.inputType,
      this.fillText,
      this.focusNode,
      this.ontap});

  @override
  Widget build(BuildContext context) {
    final commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0xFFB8BFC9),
      ),
    );
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: (ontap != null) ? ontap : null,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield!,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.all(12.0),
            border: commonBorder,
            enabledBorder: commonBorder,
            focusedBorder: commonBorder,
            disabledBorder: commonBorder,
            label: (content == "")
                ? RichText(
                    text: TextSpan(
                      text: title,
                      style: TextStyle(
                        fontSize: AppTextSizes.size15,
                        color: const Color(0xFF858080),
                      ),
                      children: [
                        if (mandatory ?? false)
                          const TextSpan(
                            text: "*",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  )
                : Text(
                    content ?? "",
                    maxLines: 2,
                    style: TextStyle(color: AppColors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                icon ?? Assets.iconUser,
                color: AppColors.primaryColor,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(maxHeight: 32, maxWidth: 32),
            suffixIcon: (dropdown ?? false)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Assets.iconDropDown),
                  )
                : const SizedBox(),
            suffixIconConstraints:
                const BoxConstraints(maxHeight: 32, maxWidth: 32),
            isDense: true,
          ),
        ),
      ),
    );
  }
}
