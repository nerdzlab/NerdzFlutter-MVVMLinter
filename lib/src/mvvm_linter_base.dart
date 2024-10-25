import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:mvvm_linter/src/rules/custom_order_rule.dart';

// Entrypoint of plugin
PluginBase createPlugin() => _PluginLints();

// The class listing all the [LintRule]s and [Assist]s defined by our plugin
class _PluginLints extends PluginBase {
  // Lint rules
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [ClassOrderRule()];
}
