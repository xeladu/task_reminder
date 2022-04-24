import 'package:flutter/cupertino.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMsg;

  const CustomErrorWidget(this.errorMsg, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMsg));
  }
}
