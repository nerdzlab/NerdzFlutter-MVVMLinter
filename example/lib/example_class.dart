// Example of another class
// ignore_for_file: avoid_print, unused_element, unused_field, prefer_final_fields, unused_local_variable

// import 'dart:ui';

class AnotherClass {
  // int a = 3;

  set as(int a) => a = a;
  set as2(int a) => a = a;

  get value => _value;
  int _value = 3;
  _setValue(int a) => _value = 3;

  int get structValue => _structValue;
  int _structValue = 0;
  _setStructValue(int structValue) => _structValue = structValue;

  void fu() {
    //
  }

  // void _foo() {
  //   int w = 2;
  // }

  // void foo2() {
  //   int w = 122;
  // }
}

// class TestClass {
//   VoidCallback? callback; // Callback
//   final AnotherClass _anotherClass = AnotherClass();

//   late final lateValue = 0;

//   /// Valuable
//   final value = 0;
//   int _s = -34;

//   // Sd
//   set sS(int v) => _s = v;
//   get s => _s;

//   void foo() {
//     int a = 0;

//     // PC do something
//   }

//   TestClass();
// }

