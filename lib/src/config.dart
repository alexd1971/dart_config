import 'package:meta/meta.dart';
import 'config_exceptions.dart';
import 'config_rule.dart';

/// Configuration base
abstract class Config {

  /// Configuration storage
  Map<String, dynamic> _config = {};

  /// Default values
  Map<String,dynamic> _defaults;

  /// Creates new configuration
  /// 
  /// `configData` -- map of configuration parameters
  /// `defaults` -- default values of configuration parameters
  /// (MUST contain values for all parameters)
  /// `builders` -- if config parameter is a subtype of [Config]
  /// you must provide a [ConfigBuilder] subtype for it (not required)
  /// `rules` -- if parameter requires some rules check
  /// you must provide a [ConfigRule] subtype for it (not required)
  Config(Map<String, dynamic> configData,
      {
        @required
        Map<String, dynamic> defaults,
        Map<String, ConfigBuilder> builders: const {},
        Map<String, ConfigRule> rules: const {}
      }):
      
    _defaults = defaults {

    configData.keys.forEach((key) {
      if (! parameters.contains(key)) {
        throw new UnknownConfigParameterException(key);
      }

      if (rules.containsKey(key)) {
        rules[key].check(key, configData[key]);
      }

      if (builders.containsKey(key)) {
        _config[key] = builders[key](configData[key]);
      } else {
        _config[key] = configData[key];
      }
    });

    defaults.keys.forEach((key) {
      if (! _config.containsKey(key)) {
        _config[key] = defaults[key];
      }
    });
  }

  /// List of all parameters
  Iterable<String> get parameters => _defaults.keys;

  /// Gets provided parameter value
  /// 
  /// If you want parameter value  type checking provide getter for each configuration parameter
  /// in [Config] subclasses
  dynamic get(String parameter) {
    if (! parameters.contains(parameter)) {
      throw new UnknownConfigParameterException(parameter);
    }
    return _config[parameter];
  }
}

typedef Config ConfigBuilder(Map<String, dynamic> configData);
