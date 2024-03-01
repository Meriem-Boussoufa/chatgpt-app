import 'package:chatgpt_app/constants/constants.dart';
import 'package:flutter/material.dart';

class ModelsDrowDownWidget extends StatefulWidget {
  const ModelsDrowDownWidget({super.key});

  @override
  State<ModelsDrowDownWidget> createState() => _ModelsDrowDownWidgetState();
}

class _ModelsDrowDownWidgetState extends State<ModelsDrowDownWidget> {
  String currentModel = "Model1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        iconEnabledColor: Colors.white,
        dropdownColor: scaffoldBackgroundColor,
        items: getModelsItem,
        value: currentModel,
        onChanged: (value) {
          setState(() {
            currentModel = value.toString();
          });
        });
  }
}
