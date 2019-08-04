import 'package:flutter/material.dart';

import '../theme.dart';

class InfoView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String info;
  final TextStyle style;
  final List<Widget> childs;

  const InfoView({
    Key key,
    @required this.icon,
    @required this.color,
    @required this.info,
    this.style,
    this.childs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: color, size: 14.0),
        PADDING_H,
        info == null
            ? SizedBox.shrink()
            : Expanded(
                child: Text(info,
                    style: style ?? textStyleInfo, textAlign: TextAlign.left),
              ),
      ]..addAll(childs ?? []),
    );
  }
}
