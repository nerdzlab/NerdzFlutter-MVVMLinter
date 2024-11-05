import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/assists/organize_assist.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/rules/custom_order_rule.dart';

// Entrypoint of plugin
PluginBase createPlugin() => _PluginLints();

// The class listing all the [LintRule]s and [Assist]s defined by our plugin
class _PluginLints extends PluginBase {
  final List<ElementType> _lintOrder = const [
    ElementType.constructor,
    ElementType.completion,
    ElementType.classObject,
    ElementType.nonChangeableProperty,
    ElementType.lateProperty,
    ElementType.otherProperty,
    ElementType.getterSetter,
    ElementType.methodPublic,
    ElementType.methodPrivate,
  ];

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) =>
      [ClassOrderRule(lintOrder: _lintOrder)];

  @override
  List<Assist> getAssists() => [OrganizeOrderAssist(lintOrder: _lintOrder)];
}
