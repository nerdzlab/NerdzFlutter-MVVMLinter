import 'dart:developer' as d;

import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/data/member_data.dart';
import 'package:mvvm_linter/src/utils/classifier.dart';

class OrganizeOrderAssist extends DartAssist {
  OrganizeOrderAssist(
      {required List<ElementType> lintOrder, bool enableLogs = false})
      : _lintOrder = lintOrder,
        _enableLogs = enableLogs;

  late final List<ElementType> _lintOrder;
  final bool _enableLogs;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    if (_enableLogs) {
      d.log('---------FIX RUN AGAIN---------');
      d.log(target.toString());
    }

    context.registry.addClassDeclaration((node) {
      if (_enableLogs) {
        d.log(node.name.toString());
        d.log(node.sourceRange.toString());
      }

      if (!target.intersects(node.sourceRange)) return;
      if (!Classifier.isNotStatefulOrStateless(node)) return;

      // Collect all members in the current class and their types
      final List<MemberData> currentClassElementsOrder = [];
      bool isNoErrorFlag = true;
      for (var member in node.members) {
        if (_enableLogs) {
          d.log("SOURCE: ${member.toSource()}");
          d.log("STRING: ${member.toString()}");
          d.log("COMMENT: ${member.sourceRange}");
          d.log("FROM NODE: ${node.declaredElement.toString()}");
        }

        final ElementType? elementType = Classifier.getElementType(member);
        if (elementType == null) continue;

        if (currentClassElementsOrder.isEmpty) {
          currentClassElementsOrder
              .add(MemberData(type: elementType, member: member));
          continue;
        }

        if (_lintOrder.indexOf(currentClassElementsOrder.last.type) >
            _lintOrder.indexOf(elementType)) {
          isNoErrorFlag = false;
        }
        currentClassElementsOrder
            .add(MemberData(type: elementType, member: member));
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
              .where((pair) => pair.type == type)
              .map((pair) => pair.member);
        }).toList();

        if (orderedMembers.length != currentClassElementsOrder.length) return;

        for (var i = 0; i < orderedMembers.length; i++) {
          // Get source code for both members
          final correctMember = orderedMembers[i];
          final currentMember = currentClassElementsOrder[i].member;

          // Get source ranges for both members
          final currentRange =
              SourceRange(currentMember.offset, currentMember.length);

          // Replace the first member with the second member's code
          builder.addReplacement(currentRange, (buffer) {
            buffer.write(correctMember.toString());
          });
        }

        builder.format(node.sourceRange);
      });
    });
  }
}
