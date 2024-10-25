
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mvvm_linter/src/data/element_type.dart';

class Classifier {
  static bool isPrimitiveType(String className) {
    return className == 'int' ||
        className == 'double' ||
        className == 'String' ||
        className == 'bool' ||
        className == 'dynamic';
  }

  static ElementType? getElementType(ClassMember member) {
    if (member is FieldDeclaration) {
      if (member.fields.variables.any(
        (element) {
          final type = element.declaredElement?.type;
          if (type is InterfaceType) {
            // If the type is an InterfaceType, it is a class or a subclass
            final classElement = type.element;
            if (classElement is ClassElement &&
                !isPrimitiveType(classElement.name)) {
              return true;
            } else {
              return false;
            }
          }
          return false;
        },
      )) {
        return ElementType.classObject;
      }

      if (member.fields.variables.any(
        (element) {
          final displayName = element.declaredElement?.getDisplayString();
          return displayName?.contains('Function') ?? false;
        },
      )) {
        return ElementType.completion;
      }

      if (member.fields.isLate) return ElementType.lateProperty;
      if (member.fields.isFinal || member.fields.isConst || member.isStatic) {
        return ElementType.nonChangeableProperty;
      }
      return ElementType.otherProperty;
    } else if (member is MethodDeclaration) {
      if (member.isGetter || member.isSetter) return ElementType.getterSetter;
      return ElementType.method;
    } else if (member is ConstructorDeclaration) {
      return ElementType.constructor;
    }

    return null;
  }

  static bool isNotStatefulOrStateless(ClassDeclaration node) =>
      node.declaredElement?.allSupertypes.any((element) {
        final className =
            node.extendsClause?.superclass.type?.getDisplayString();
        if (className == 'StatefulWidget' || className == 'StatelessWidget') {
          return false;
        }
        return true;
      }) ??
      false;
}
