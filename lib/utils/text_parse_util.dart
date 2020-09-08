import 'package:flutter/material.dart';
import 'package:recook/constants/header.dart';

class TextParseUtil {
  static TextStyle addressTextStyle = defaultTextStyle.copyWith(
    fontWeight: FontWeight.w500,
  );

  static TextStyle blackTextStyle = defaultTextStyle.copyWith(
    color: Color(0xFF333333),
    fontWeight: FontWeight.bold,
  );

  static TextStyle defaultTextStyle = TextStyle(
    fontSize: ScreenAdapterUtils.setSp(14),
    color: Color(0xFF666666),
  );

  static TextStyle greyTextStyle = defaultTextStyle.copyWith(
    color: Color(0xFF999999),
  );

  static const String tagRegEx = "(<.*?>)(.*?)(<\/.*?>)";

  static Widget parseRefundText(String raw) {
    String rawText = raw;
    List<String> lines = [];
    List<Widget> rows = [];
    //parse line
    if (rawText.contains('|')) {
      lines = rawText.split('|');
    } else {
      lines = [rawText];
    }
    lines.forEach((singleLine) {
      int index = 0;
      List<InlineSpan> parts = [];

      RegExp(tagRegEx).allMatches(singleLine).forEach((element) {
        String normalText = singleLine.substring(index, element.start);
        index = element.end;
        String tag = singleLine.substring(element.start, element.end);
        print(tag);
        parts.add(TextSpan(
          text: normalText,
          style: defaultTextStyle,
        ));
        if (_parseTagText(tag) is Widget) {
          parts.add(TextSpan(text: ''));
          rows.add(Row(
            children: <Widget>[_parseTagText(tag)],
          ));
        } else {
          parts.add(_parseTagText(tag));
        }
      });
      String last = singleLine.substring(index);
      parts.add(TextSpan(
        text: last,
        style: defaultTextStyle,
      ));
      rows.add(Text.rich(
        TextSpan(
          children: parts,
        ),
      ));
      rows.add(SizedBox(height: ScreenAdapterUtils.setHeight(6)));
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  static _parseTagText(String text) {
    String midText =
        text.substring(text.indexOf('>') + 1, text.lastIndexOf('<'));
    if (text.contains('black'))
      return TextSpan(text: midText, style: blackTextStyle);
    else if (text.contains('gray'))
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(
            ScreenAdapterUtils.setHeight(8),
          ),
          child: Text(midText, style: greyTextStyle),
        ),
      );
    else
      return TextSpan(text: midText, style: addressTextStyle);
  }
}
