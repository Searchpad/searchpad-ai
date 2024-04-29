import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomInput extends StatelessWidget {
  final ValueChanged<String?>? onChanged;
  final String? hint;
  final String? labelText;
  final String? name;
  final int? maxLines;
  final double? upperHeight;
  final double? lowerHeight;
  final String? initialValue;
  final Widget? suffix;
  final Widget? prefix;
  final TextCapitalization? textCapitalization;
  final Widget? icon;
  final List<String? Function(String?)>? validators;
  final TextInputType textInputType;
  final double? borderCircular;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputAction? textInputAction;
  final Iterable<String>? autoFillHint;
  final TextEditingController? controller;

  final InputBorder? inputBorder;
  const CustomInput(
      {Key? key,
      this.onChanged,
      this.hint,
      this.inputBorder,
      required this.name,
      this.validators,
      required this.textInputType,
      this.maxLines,
      this.upperHeight,
      this.lowerHeight,
      this.icon,
      this.textCapitalization,
      this.initialValue,
      this.suffix,
      this.borderCircular,
      this.inputFormatter,
      this.textInputAction,
      this.controller,
      this.labelText,
      this.prefix,
      this.autoFillHint})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UIHelper.verticalSpace(upperHeight ?? 8.0),
        FormBuilderTextField(
          autofillHints: autoFillHint,
          controller: controller,
          name: name!,
          initialValue: initialValue,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
              // fillColor: textBoxBackgroundColor,
              // focusColor: textBoxBackgroundColor,
              contentPadding:
                  const EdgeInsets.only(left: 25, top: 20, bottom: 20),
              // fillColor: Colors.amber,
              labelText: hint,
              hintText: labelText,
              suffix: suffix,
              prefix: prefix,
              // labelStyle: const TextStyle(color: textBoxTextColor),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 215, 215, 215)),
                  borderRadius: BorderRadius.circular(borderCircular ?? 50)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(borderCircular ?? 50)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(borderCircular ?? 50)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(borderCircular ?? 50)),
              prefixIcon: icon),
          validator: FormBuilderValidators.compose(validators ?? []),
          keyboardType: textInputType,
          textCapitalization: textCapitalization ?? TextCapitalization.words,
          textInputAction: textInputAction ?? TextInputAction.done,
          inputFormatters: inputFormatter,
        ),
        UIHelper.verticalSpace(lowerHeight ?? 8),
      ],
    );
  }
}
