# Configuration support library

Different services need using different configuration parameters to run. This library makes it easy to create a configuration object with any set of parameters from `Map` of parameter's values. The `Map` can be obtained in any suitable way, for example, from yaml-file or by http.

You will never forget to set default values for all parameters.
You can easyly set rules checking for any parameter value
Any parameter can be also a configuration object.

To get parameter value for your service is as easy as `config.parameter`

## Usage

A simple usage example:

```dart
import 'package:config/config.dart';

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
```

Full usage example see in the example directory