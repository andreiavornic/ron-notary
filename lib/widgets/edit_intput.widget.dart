import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notary/methods/resize_formatting.dart';

class EditInput extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final String hintText;
  final Widget suffixIcon;
  final Widget prefix;
  final Widget prefixIcon;
  final bool obscureText;
  final bool autofocus;
  final bool readOnly;
  final Function unfocus;
  final String validator;
  final Function validate;
  final Function onChanged;
  final Function onTap;
  final Function onFieldSubmitted;
  final TextInputType keyboardType;
  final int maxLines;
  final Key key;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final TextInputAction action;
  final bool noCapitalize;
  final int maxLength;

  EditInput({
    this.labelText,
    this.initialValue,
    this.hintText,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.obscureText,
    this.autofocus,
    this.readOnly,
    this.unfocus,
    this.validator,
    this.validate,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.keyboardType,
    this.maxLines,
    this.key,
    this.inputFormatters,
    this.controller,
    this.action,
    this.noCapitalize,
    this.maxLength,
  });

  @override
  _EditInputState createState() => _EditInputState();
}

class _EditInputState extends State<EditInput> {
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      children: [
        Container(
          //  height: 50,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enableSuggestions: false,
            textCapitalization:
                widget.noCapitalize != null && widget.noCapitalize
                    ? TextCapitalization.none
                    : TextCapitalization.words,
            obscureText:
                widget.obscureText != null ? widget.obscureText : false,
            key: widget.key != null ? widget.key : null,
            controller: widget.controller,
            maxLines: widget.maxLines != null ? widget.maxLines : 1,
            readOnly: widget.readOnly != null ? widget.readOnly : false,
            onTap: widget.onTap != null ? widget.onTap : null,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon != null ? widget.suffixIcon : null,
              prefix: widget.prefix != null ? widget.prefix : null,
              prefixIcon: widget.prefixIcon != null ? widget.prefixIcon : null,
              contentPadding: EdgeInsets.only(bottom: 10, top: 5),
              suffixStyle: TextStyle(
                color: Color(0xFFADAEAF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              errorStyle: TextStyle(
                color: Color(0xFFFF4E4E),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 0.5,
              ),
              // filled: true,
              hintText: widget.hintText != null ? widget.hintText : "Empty",
              labelText: widget.labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintStyle: TextStyle(
                color: Color(0xFFADAEAF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              focusColor: Color(0xFFADAEAF),
              labelStyle: TextStyle(
                color: Color(0xFF161617),
                // Color(0xFFB5B5B5),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              focusedBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: Color(0xFFC7CFDC),
                  width: 1,
                ),
              ),
              enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: Color(0xFFEDEDED),
                  width: 1,
                ),
              ),
              errorBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: Color(0xFFFF4E4E),
                  width: 1,
                ),
              ),
            ),
            textInputAction:
                widget.action != null ? widget.action : TextInputAction.next,
            onEditingComplete: widget.unfocus != null
                ? widget.unfocus
                : () => node.nextFocus(),
            keyboardType: widget.keyboardType != null
                ? widget.keyboardType
                : TextInputType.visiblePassword,
            autocorrect: false,
            autofocus: widget.autofocus != null ? widget.autofocus : false,
            inputFormatters:
                widget.inputFormatters != null ? widget.inputFormatters : null,
            maxLength: widget.maxLength != null ? widget.maxLength : null,
            style: TextStyle(
              color: Color(0xFF161617),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            validator: widget.validate != null ? widget.validate : null,
            onSaved: (value) => widget.onChanged(value),
            onChanged: (value) {
              widget.onChanged(value);
            },
            initialValue:
                widget.initialValue != null ? widget.initialValue : null,
            onFieldSubmitted: (value) => widget.onFieldSubmitted != null
                ? widget.onFieldSubmitted(value)
                : null,
          ),
        ),
        SizedBox(
          height: reSize(5),
        )
      ],
    );
  }
}
