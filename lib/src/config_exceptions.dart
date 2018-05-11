class ConfigParameterException implements Exception {
  final String paramName;
  final dynamic paramValue;

  const ConfigParameterException(this.paramName, this.paramValue);

  @override
  String toString() {
    return 'ConfigParameterException: $paramName => $paramValue';
  }
}

class UnknownConfigParameterException extends ConfigParameterException {
  const UnknownConfigParameterException(String paramName)
      : super(paramName, null);

  @override
  String toString() {
    return 'UnknownConfigParameterException: unknown parameter "$paramName"';
  }
}

class ConfigValueException extends ConfigParameterException {
  
  final dynamic _expected;

  const ConfigValueException(String paramName, dynamic paramValue, dynamic expected)
      : _expected = expected, super(paramName, paramValue);

  @override
  String toString() {
    return 'ConfigValueException: parameter "$paramName" cannot be set to "$paramValue". Expected: $_expected.';
  }
}

class ConfigParameterTypeException extends ConfigParameterException {
  final Type expextedType;

  const ConfigParameterTypeException(
      String paramName, dynamic paramValue, Type expectedType)
      : this.expextedType = expectedType,
        super(paramName, paramValue);

  @override
  String toString() {
    return 'ConfigParameterTypeException: parameter "$paramName" has type "${paramValue.runtimeType}". Expected: "$expextedType"';
  }
}
