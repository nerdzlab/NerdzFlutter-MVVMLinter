part of 'custom_order_rule.dart';

class _OrganizeOrder extends DartFix {
  _OrganizeOrder({required List<ElementType> lintOrder})
      : _lintOrder = lintOrder;

  late final List<ElementType> _lintOrder;

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    error.AnalysisError analysisError,
    List<error.AnalysisError> others,
  ) {
    d.log('FIX RUN AGAIN');

    context.registry.addClassDeclaration((node) {
      if (!Classifier.isNotStatefulOrStateless(node)) return;

      // Collect all members in the current class and their types
      final List<(ElementType, ClassMember)> currentClassElementsOrder = [];
      for (var member in node.members) {
        final ElementType? elementType = Classifier.getElementType(member);
        if (elementType != null) {
          currentClassElementsOrder.add((elementType, member));
        }
      }

      if (currentClassElementsOrder.isEmpty) return;

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
            buffer.write(correctMember.toSource());
          });
        }
      });
    });
  }
}
