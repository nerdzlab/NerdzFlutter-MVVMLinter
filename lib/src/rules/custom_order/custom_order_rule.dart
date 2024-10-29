import 'dart:developer' as d;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/utils/classifier.dart';

part 'custom_order_fix.dart';

class ClassOrderRule extends DartLintRule {
  ClassOrderRule(
      {
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
      List<ElementType> lintOrder = const [
        ElementType.constructor,
        ElementType.completion,
        ElementType.classObject,
        ElementType.nonChangeableProperty,
        ElementType.lateProperty,
        ElementType.otherProperty,
        ElementType.getterSetter,
        ElementType.method,
      ]})
      : _lintOrder = lintOrder,
        super(code: _code);

  /// Correct order in class
  late final List<ElementType> _lintOrder;
  final List<ElementType> _currentClassElementsOrder = [];

  static const _code = LintCode(
    name: 'class_order_rule',
    problemMessage: 'Class order is not right!',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration(
      (node) {
        d.log('------------------------------------');
        d.log('CLASS MEMBER: ${node.declaredElement?.name}');

        if (!Classifier.isNotStatefulOrStateless(node)) return;

        _currentClassElementsOrder.clear();

        for (var member in node.members) {
          final ElementType? elementType = Classifier.getElementType(member);
          d.log('CLASS m.type: $elementType');

          if (elementType == null) continue;

          if (_currentClassElementsOrder.isEmpty) {
            _currentClassElementsOrder.add(elementType);
            continue;
          }

          d.log(
              'CLASS index: ${_lintOrder.indexOf(_currentClassElementsOrder.last)} : ${_lintOrder.indexOf(elementType)}');
          if (_lintOrder.indexOf(_currentClassElementsOrder.last) >
              _lintOrder.indexOf(elementType)) {
            reporter.atEntity(
                member,
                LintCode(
                    name: 'class_order_rule',
                    problemMessage:
                        '${elementType.getDisplayName()} should be before ${_currentClassElementsOrder.last.getDisplayName()}'));
          }

          _currentClassElementsOrder.add(elementType);
        }
      },
    );
  }

  @override
  List<Fix> getFixes() => [_OrganizeOrder(lintOrder: _lintOrder)];
}
