// Example of another class
// ignore_for_file: avoid_print, unused_element, unused_field, prefer_final_fields

import 'dart:ui';

class AnotherClass {}

class TestClass {
  TestClass();
  VoidCallback? callback; // Callback
  final AnotherClass _anotherClass = AnotherClass();

  final value = 0;
  late final lateValue = 0;
  int _s = -34;


  get s => _s;
  set sS(int v) => _s = v;

  void foo() {}
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
