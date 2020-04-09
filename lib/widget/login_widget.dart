import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/theme/theme_model.dart';

class LoginTopPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return ClipPath(
      clipper: BottomClipper(),
      child: Container(
        height: 200,
        color: appTheme.themeColor,
      ),
    );
  }
}

class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Hero(
      tag: "loginlogo",
      child: Image.asset(
        "assets/img/ic_avatar.png",
        width: 230,
        height: 200,
        fit: BoxFit.fitWidth,
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

class LoginFormContainer extends StatelessWidget {
  final Widget child;

  LoginFormContainer({this.child});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<ThemeModel>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(),
          color: appTheme.themeColor,
          shadows: [
            BoxShadow(
              color: appTheme.themeColor.withAlpha(20),
              offset: Offset(1.0, 1.0),
              blurRadius: 10.0,
              spreadRadius: 3.0,
            )
          ]),
      child: child,
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}