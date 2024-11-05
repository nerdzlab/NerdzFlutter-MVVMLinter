enum ElementType {
  constructor,
  completion,
  classObject,
  nonChangeableProperty,
  lateProperty,
  otherProperty,
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
        getterSetter => 'Getters or Setters',
        methodPublic => 'Public Methods',
        methodPrivate => 'Private Methods',
      };
}
