// Example of another class
// ignore_for_file: avoid_print, unused_element, unused_field, prefer_final_fields

import 'dart:ui';

class AnotherClass {
  set as(int a) => a = a;
  int a = 3;
}

class TestClass {
  VoidCallback? callback; // Callback
  final AnotherClass _anotherClass = AnotherClass();

  late final lateValue = 0;

  /// Valuable
  final value = 0;
  int _s = -34;

  // Sd
  set sS(int v) => _s = v;
  get s => _s;

  void foo() {
    int a = 0;

    // PC do something
  }

  TestClass();
}

      /// Structure of viewModel should be:
      ///
      /// - constructor -- ConstructorDeclarationImpl
      /// - completions -- CallBacks FieldDeclarationImpl
      /// - repositories -- FieldDeclarationImpl
      /// - final properties public/private -- FieldDeclarationImpl
      /// - late properties public/private -- FieldDeclarationImpl
      /// - get/set properties public/private -- MethodDeclarationImpl
      /// - methods public/private -- MethodDeclarationImpl
      ///
