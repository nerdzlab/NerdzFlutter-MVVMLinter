import 'dart:developer' as d;

import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/data/member_data.dart';
import 'package:mvvm_linter/src/utils/classifier.dart';

class ClassOrderRule extends DartLintRule {
  ClassOrderRule(
      {required List<ElementType> lintOrder, bool enableLogs = false})
      : _lintOrder = lintOrder,
        _enableLogs = enableLogs,
        super(code: _code);

  // Correct order in class
  late final List<ElementType> _lintOrder;

  final bool _enableLogs;

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
    // Listen for any classes.
    //
    // On open of project, files. Editing or cursor changing
    context.registry.addClassDeclaration(
      (node) {
        if (_enableLogs) {
          d.log('------------------------------------');
          d.log('CLASS MEMBER: ${node.declaredElement?.name}');
        }

        // Ignore analyze if this class stateless or stateful
        if (!Classifier.isNotStatefulOrStateless(node)) return;

        final List<MemberData> currentClassElementsOrder = [];

        // Collecting all class members (values, methods, etc)
        for (var member in node.members) {
          final ElementType? elementType = Classifier.getElementType(member);
          if (_enableLogs) {
            d.log('CLASS m.type: $elementType');
          }

          // Unknown element type
          if (elementType == null) continue;

          // First element, no need in analyze
          if (currentClassElementsOrder.isEmpty) {
            currentClassElementsOrder
                .add(MemberData(type: elementType, member: member));
            continue;
          }

          currentClassElementsOrder
              .add(MemberData(type: elementType, member: member));
        }

        // Replacing special sequence/structs
        List<MemberData> formattedList =
            Classifier.detectSequences(currentClassElementsOrder);

        // Reporting
        for (var i = 1; i < formattedList.length; i++) {
          if (_lintOrder.indexOf(formattedList[i - 1].type) >
              _lintOrder.indexOf(formattedList[i].type)) {
            final errorCode = LintCode(
                name: 'class_order_rule',
                problemMessage:
                    '${formattedList[i].type.getDisplayName()} should be before ${formattedList[i - 1].type.getDisplayName()}');

            if (formattedList[i].members.isNotEmpty) {
              reporter.atOffset(
                  offset: formattedList[i].members.first.offset,
                  length: formattedList[i].members.last.end -
                      formattedList[i].members.first.offset,
                  errorCode: errorCode);
            } else {
              reporter.atEntity(formattedList[i].member, errorCode);
            }
          }
        }
      },
    );
  }
}
