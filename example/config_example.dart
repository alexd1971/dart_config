import 'package:config/config.dart';

/// Demonstraits using config library
main() {
  // Getting somehow config data
  final Map<String, dynamic> configData = getConfigData();

  // Creating config
  final config = new MyServiceConfig(configData);

  // Using config parameters
  print(config.stringParam);
  print(config.intParam);
  print(config.subconfig.param);

}

/// Gets config data
/// 
/// Mock-function returns just Map
/// Real action can read data from yaml-file or via http
Map<String, dynamic> getConfigData() =>
  <String, dynamic> {
    'stringParam': 'string value',
    'intParam': 5,
    'subconfig': {
      'param': 'param value'
    }
  };

/// Description of service configuration parameters
class MyServiceConfig extends Config {

  /// Default values (required)
  static final Map<String, dynamic> _defaults = {
    'stringParam': 'default string',
    'intParam': 0,
    'subconfig': new MyServiceSubconfig()
  };

  /// Rules to check config parameters (not required)
  static final Map<String, ConfigRule> _rules = {
    'stringParam': ConfigRule.isString,
    'intParam': new intParamRule(),
    'subconfig': ConfigRule.isMap
  };

  /// Config bulders (not required)
  /// 
  /// If a parameter is a child-config then you must declare how to create it
  static final Map<String, ConfigBuilder> _builders = {
    'subconfig': (Map<String, dynamic> configData) => new MyServiceSubconfig(configData)
  };

  /// Creates new service configuration
  MyServiceConfig([Map<String, dynamic> configData])
    : super(configData ?? {}, defaults: _defaults, rules: _rules, builders: _builders);

  /// `stringParam` getter
  String get stringParam => get('stringParam') as String;

  /// `intParam` getter
  int get intParam => get('intParam') as int;

  /// `subconfig` getter
  MyServiceSubconfig get subconfig => get('subconfig') as MyServiceSubconfig;

}

/// Custom rule for `intParam`
/// 
/// `check` function returns normally if everythin is OK or throws an [Exception]
class intParamRule implements ConfigRule {
  @override
  check(String name, dynamic value) {
    ConfigRule.isInt.check(name, value);
    if (value < 0 || value > 10) {
      throw new ConfigValueException(name, value, 'greater then 0 and less then 10');
    }
  }
}

/// Service child-config
class MyServiceSubconfig extends Config {

  static final Map<String, dynamic> _defaults = {
    'param': 'default subconfig param value'
  };

  static final Map<String, dynamic> _rules = {
    'param': ConfigRule.isString
  };

  MyServiceSubconfig([Map<String,dynamic> configData])
    : super(configData ?? {}, defaults: _defaults, rules: _rules);
  
  String get param => get('param') as String;
}

