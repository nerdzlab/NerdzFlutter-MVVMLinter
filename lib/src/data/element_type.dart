enum ElementType {
  constructor,
  completion,
  classObject,
  nonChangeableProperty,
  lateProperty,
  otherProperty,

  /// Special structure:
  /// 1. getter -> value(getter.name == (_) + value.name) -> setter((_set) + value.name)
  ///
  /// CODE:
  ///    @override
  ///    bool get isResendEnable => _isResendEnable;
  ///
  ///    bool _isResendEnable = false;
  ///
  ///    _setIsResendEnable(bool value) {
  ///      _isResendEnable = value;
  ///      notifyListeners();
  ///    }
  getterSetterStruct,
  getterSetter,
  methodPublic,
  methodPrivate;

  String getDisplayName() => switch (this) {
        constructor => 'Constructors',
        completion => 'Completions',
        classObject => 'Class Objects',
        nonChangeableProperty => 'Final/Const/Static Properties',
        lateProperty => 'Late Properties',
        otherProperty => 'Non Final/Const/Static/Late Properties',
        getterSetterStruct => 'Special structure, get->_value->set',
        getterSetter => 'Getters or Setters',
        methodPublic => 'Public Methods',
        methodPrivate => 'Private Methods',
      };
}
