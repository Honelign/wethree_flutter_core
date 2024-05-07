import 'package:global_configuration/global_configuration.dart';

class Config {
  void loadFromMap(Map<String, dynamic> map) {
    GlobalConfiguration().loadFromMap(map);
  }
  
  void addValue(String key,dynamic value) {
    GlobalConfiguration().addValue(key,value);
  }

  void updateValue(String key,dynamic value) {
    GlobalConfiguration().updateValue(key,value);
  }

  dynamic readValue(String key) => GlobalConfiguration().getValue(key);
}
