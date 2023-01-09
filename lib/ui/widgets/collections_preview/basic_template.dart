import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class PreviewContainer extends StatelessWidget {
  final Function() onTap;
  final Template template;

  PreviewContainer({
    this.onTap,
    this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constants.width10,
        vertical: Constants.height10,
      ),
      width: Constants.width300,
      height: Constants.height200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Colors.white,
        border: Border.all(color: Color(0xff313131).withOpacity(0.1)),
      ),
      child: GestureDetector(
        onTap: () {
          final bloc = Provider.of<NavigatorScreenBloc>(context, listen: false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Provider.value(
                  value: template,
                  child: ConstructorScreen(
                    navigatorScreenBloc: bloc,
                    template: template,
                    fromSave: false,
                  ),
                );
              },
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
          child: Container(
            width: Constants.width280,
            height: Constants.height180,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Image.asset(
                template.previewFilePath,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
