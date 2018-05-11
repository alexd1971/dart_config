import 'package:test/test.dart';

import 'package:config/config.dart';

/// Simple config for testing [Config]
class SimpleConfig extends Config {
  static final _defaults = <String, dynamic>{
    'string': 'default string',
    'integer': 54321
  };

  SimpleConfig(Map<String, dynamic> configData)
      : super(configData, defaults: _defaults);

  /// Sample string parameter
  String get string => get('string') as String;

  /// Sample integer parameter
  int get integer => get('integer') as int;
}

/// Simple config with parameter checking rules
class SimpleConfigWithRules extends Config {
  static final _defaults = <String, dynamic>{
    'string': 'default string',
    'integer': 54321
  };

  static final _rules = <String, ConfigRule>{
    'string': ConfigRule.isString,
    'integer': ConfigRule.isInt
  };

  SimpleConfigWithRules(Map<String, dynamic> configData)
      : super(configData, defaults: _defaults, rules: _rules);

  /// Sample string parameter
  String get string => get('string') as String;

  /// Sample integer parameter
  int get integer => get('integer') as int;
}

/// Complex config with builders
class ConfigWithBuilders extends Config {
  static final _defaults = <String, dynamic>{
    'parameter': 'default value',
    'object': new SimpleConfig({})
  };

  static final _builders = <String, ConfigBuilder>{
    'object': (Map<String, dynamic> configData) {
      return new SimpleConfig(configData);
    }
  };

  ConfigWithBuilders(Map<String, dynamic> configData)
      : super(configData, defaults: _defaults, builders: _builders);

  /// Sample string parameter
  String get parameter => get('parameter') as String;

  /// Sample parameter of type [SimpleConfig]
  SimpleConfig get object => get('object') as SimpleConfig;
}

void main() {
  test('create simple config', () {
    final Map<String, dynamic> configData = const {
      'string': 'string value',
      'integer': 12345
    };

    final config = new SimpleConfig(configData);

    expect(config.string, 'string value');
    expect(config.integer, 12345);
  });

  test('set defaults', () {
    final config = new SimpleConfig({});

    expect(config.string, 'default string');
    expect(config.integer, 54321);
  });

  test('parameters list', () {
    final config = new SimpleConfig({});

    expect(config.parameters, ['string', 'integer']);
  });

  test('check rules', () {
    final Map<String, dynamic> configData = const {
      'string': 'string value',
      'integer': '11111'
    };

    expect(() {
      new SimpleConfigWithRules(configData);
    }, throwsA(new isInstanceOf<ConfigParameterTypeException>()));
  });

  test('builders', () {
    final configData = <String, dynamic>{
      'parameter': 'value',
      'object': {'string': 'string value', 'integer': 12345}
    };

    final config = new ConfigWithBuilders(configData);

    expect(config.parameter, 'value');
    expect(config.object.string, 'string value');
    expect(config.object.integer, 12345);
  });

  test('builders with defaults', () {
    final config = new ConfigWithBuilders({});

    expect(config.parameter, 'default value');
    expect(config.object.string, 'default string');
    expect(config.object.integer, 54321);
  });
}
