import 'package:flutter/material.dart';

import '../theme.dart';

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  final String label;
  final ValueChanged<BuildContext> onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Colors.black,
      onPressed: () => onPressed(context),
      shape: StadiumBorder(),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

Scaffold getMyScaffold(
  String title, {
  key: Key,
  titleAlign: TextAlign,
  body: Widget,
  drawer: Drawer,
  leading: Widget,
  onLeadingPressed: VoidCallback,
  floatingActionButton: Widget,
  floatingActionButtonLocation: FloatingActionButtonLocation,
  bottomNavigationBar: Widget,
}) {
  return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      // Appbar
      appBar: AppBar(
        title: Text(
          title,
          style: textStyle1,
          textAlign: titleAlign ?? TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        leading: leading ??
            IconButton(
                icon: Icon(Icons.arrow_back, color: colorPrimaryDark),
                onPressed: onLeadingPressed),
      ),
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar);
}

Scaffold getCommonScaffold(
  String title, {
  Widget body,
  double elevation = 0.0,
  VoidCallback onLeadingPressed,
}) {
  return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: textStyle1,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        elevation: elevation ?? 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorPrimaryDark,
          ),
          onPressed: onLeadingPressed,
        ),
      ),
      body: body);
}
