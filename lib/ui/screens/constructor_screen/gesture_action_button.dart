import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class GestureActionButton extends StatelessWidget {
  final ButtonClass buttonClass;

  GestureActionButton({@required this.buttonClass})
      : assert(buttonClass != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Provider.of<DynamicTemplateEngine>(context).getHeight(
        Provider.of<double>(context),
      ),
      height: Provider.of<DynamicTemplateEngine>(context).getHeight(
        Provider.of<double>(context),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0xffbfbfbf), offset: Offset(0, 0), blurRadius: 4)
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          buttonClass == ButtonClass.SCALE
              ? 'assets/icons/scale.svg'
              : buttonClass == ButtonClass.ROTATE
                  ? 'assets/icons/rotate.svg'
                  : 'assets/icons/delete_text.svg',
          width: Provider.of<DynamicTemplateEngine>(context).getWidth(56),
          height: Provider.of<DynamicTemplateEngine>(context).getWidth(56),
        ),
      ),
    );
  }
}
