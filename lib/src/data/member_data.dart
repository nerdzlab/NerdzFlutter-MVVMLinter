// ignore_for_file: prefer_initializing_formals

import 'package:analyzer/dart/ast/ast.dart';
import 'package:mvvm_linter/src/data/element_type.dart';

class MemberData {
  MemberData({
    required this.type,
    required this.member,
    this.members = const [],
  });

  final ElementType type;

  final ClassMember member;
  final List<ClassMember> members;
}
