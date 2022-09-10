import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input_Text_Field extends StatelessWidget {
  final Controller_Text_Filed;
  final input_action;
  final input_Type;
  final labele_Text;
  final input_text_focus_Node;
  final on_Field_Submitted;
  final error_text;
  final myRegExpression;

  Input_Text_Field({
    @required this.error_text,
    @required this.Controller_Text_Filed,
    @required this.input_action,
    @required this.input_text_focus_Node,
    @required this.input_Type,
    @required this.labele_Text,
    @required this.on_Field_Submitted,
    @required this.myRegExpression,
  });

  @override
  Widget build(BuildContext context) {
    Color border_Color = Colors.green;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: border_Color),
          borderRadius: BorderRadius.circular(30)),
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter(myRegExpression)
              ],
              cursorColor: Colors.green,
              controller: Controller_Text_Filed,
              toolbarOptions:
                  ToolbarOptions(cut: true, paste: true, selectAll: true),
              textInputAction: input_action,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: input_Type,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: labele_Text,
                  labelStyle: TextStyle(color: Colors.green)),
              focusNode: input_text_focus_Node,
              onFieldSubmitted: on_Field_Submitted,
              validator: (value) {
                return value.isEmpty ? error_text : null;
              }),
        ],
      ),
    );
  }
}
