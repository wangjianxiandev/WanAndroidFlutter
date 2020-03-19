import 'package:flutter/material.dart';

class SingleSelectTagView extends StatelessWidget {

  final int index; //为标识选中的
  final parent; //父控件
  final String choiceText;


  const SingleSelectTagView(
      {@required this.index,
        @required this.parent,
        @required this.choiceText})
      : super();

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
          label: Text(choiceText,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          //选定的时候背景
          selectedColor: Theme.of(context).primaryColor,
          //未选用得时候背景
          disabledColor: Colors.grey[300],
          labelStyle: TextStyle(fontWeight: FontWeight.w200, fontSize: 15.0),
          labelPadding: EdgeInsets.only(left: 8.0, right: 8.0),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onSelected: (bool value) {
            parent.onSelectedChanged(index);
          },
          selected: parent.selectedType == index),
    );
  }
}