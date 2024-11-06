import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/assists/organize_assist.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/rules/custom_order_rule.dart';

// Entrypoint of plugin
PluginBase createPlugin() => _PluginLints();

// The class listing all the [LintRule]s and [Assist]s defined by our plugin
class _PluginLints extends PluginBase {
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
  final List<ElementType> _lintOrder = const [
    ElementType.constructor,
    ElementType.completion,
    ElementType.classObject,
    ElementType.nonChangeableProperty,
    ElementType.lateProperty,
    ElementType.otherProperty,
    ElementType.getterSetterStruct,
    ElementType.getterSetter,
    ElementType.methodPublic,
    ElementType.methodPrivate,
  ];

  final bool _enableDebugLogs = true;

  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) =>
      [ClassOrderRule(lintOrder: _lintOrder, enableLogs: _enableDebugLogs)];

  @override
  List<Assist> getAssists() => [OrganizeOrderAssist(lintOrder: _lintOrder)];
}
