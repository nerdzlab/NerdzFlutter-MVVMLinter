import 'dart:developer' as d;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/utils/classifier.dart';

class OrganizeOrderAssist extends DartAssist {
  OrganizeOrderAssist({required List<ElementType> lintOrder})
      : _lintOrder = lintOrder;

  late final List<ElementType> _lintOrder;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    d.log('---------FIX RUN AGAIN---------');
    d.log('${target.toString()}');

    context.registry.addClassDeclaration((node) {
      d.log(node.name.toString());
      d.log(node.sourceRange.toString());

      if (!target.intersects(node.sourceRange)) return;
      if (!Classifier.isNotStatefulOrStateless(node)) return;

      // Collect all members in the current class and their types
      final List<(ElementType, ClassMember)> currentClassElementsOrder = [];
      bool isNoErrorFlag = true;
      for (var member in node.members) {
        d.log("SOURCE: ${member.toSource()}");
        d.log("STRING: ${member.toString()}");
        d.log("COMMENT: ${member.sourceRange}");
        d.log("FROM NODE: ${node.declaredElement.toString()}");

        final ElementType? elementType = Classifier.getElementType(member);
        if (elementType == null) continue;

        if (currentClassElementsOrder.isEmpty) {
          currentClassElementsOrder.add((elementType, member));
          continue;
        }

        if (_lintOrder.indexOf(currentClassElementsOrder.last.$1) >
            _lintOrder.indexOf(elementType)) {
          isNoErrorFlag = false;
        }
        currentClassElementsOrder.add((elementType, member));
      }

      if (currentClassElementsOrder.isEmpty || isNoErrorFlag) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Organize class members',
        priority: 1,
      );

      changeBuilder.addDartFileEdit((builder) {
        // Organize members by desired order
        final orderedMembers = _lintOrder.expand((type) {
          return currentClassElementsOrder
              .where((pair) => pair.$1 == type)
              .map((pair) => pair.$2);
        }).toList();

        if (orderedMembers.length != currentClassElementsOrder.length) return;

        for (var i = 0; i < orderedMembers.length; i++) {
          // Get source code for both members
          final correctMember = orderedMembers[i];
          final currentMember = currentClassElementsOrder[i].$2;

          // Get source ranges for both members
          final currentRange =
              SourceRange(currentMember.offset, currentMember.length);

          // Replace the first member with the second member's code
          builder.addReplacement(currentRange, (buffer) {
            buffer.write(correctMember.toString());
          });
        }
      });
    });
  }
}
