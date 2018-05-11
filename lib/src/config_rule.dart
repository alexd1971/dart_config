import 'config_exceptions.dart';

abstract class ConfigRule {
  
  static final ConfigRule isString = new _IsString();
  static final ConfigRule isInt = new _IsInt();
  static final ConfigRule isList = new _IsList();
  static final ConfigRule isMap = new _IsMap();

  void check(String name, dynamic value);
}

class _IsString implements ConfigRule{
  void check(String name, dynamic value) {
    if (value.runtimeType != String) {
      throw new ConfigParameterTypeException(name, value, String);
    }
  }
}

class _IsInt implements ConfigRule{
  void check(String name, dynamic value) {
    if (value.runtimeType != int) {
      throw new ConfigParameterTypeException(name, value, int);
    }
  }
}

class _IsList implements ConfigRule{
  void check(String name, dynamic value) {
    if (! (value is List)) {
      throw new ConfigParameterTypeException(name, value, List);
    }
  }
}

class _IsMap implements ConfigRule{
  void check(String name, dynamic value) {
    if (! (value is Map)) {
      throw new ConfigParameterTypeException(name, value, Map);
    }
  }
}