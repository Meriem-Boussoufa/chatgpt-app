import 'package:chatgpt_app/services/api_service.dart';
import 'package:flutter/material.dart';

import '../models/model.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<Model> modelsList = [];
  List<Model> get getModelsList {
    return modelsList;
  }

  Future<List<Model>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
