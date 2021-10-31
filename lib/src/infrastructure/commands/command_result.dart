class CommandResult<TValue> {
  String? _error;
  TValue? _value;

  CommandResult._();

  CommandResult.success(TValue value) {
    _value = value;
  }

  CommandResult.failure(String error) {
    _error = error;
  }

  bool get isSuccess {
    return _error == null;
  }

  bool get isFailure {
    return _error != null;
  }

  TValue get value {
    if (isFailure) {
      throw "Failure result has no value!";
    }

    return _value!;
  }

  String get error {
    if (isSuccess) {
      throw "Success result has no error!";
    }

    return _error!;
  }
}