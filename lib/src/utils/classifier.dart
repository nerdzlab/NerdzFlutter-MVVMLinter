import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:mvvm_linter/src/data/element_type.dart';
import 'package:mvvm_linter/src/data/member_data.dart';

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
      return member.name.lexeme.startsWith("_")
          ? ElementType.methodPrivate
          : ElementType.methodPublic;
    } else if (member is ConstructorDeclaration) {
      return ElementType.constructor;
    }

    return null;
  }

  static bool isGetter(ClassMember member) =>
      (member is MethodDeclaration) ? member.isGetter : false;
  static bool isSetter(ClassMember member) =>
      (member is MethodDeclaration) ? member.isSetter : false;

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

  static List<MemberData> detectSequences(List<MemberData> memberData) {
    List<MemberData> formattedList = List.from(memberData);
    int index = 0;
    int sequenceLength = 3;

    while (index <= formattedList.length - sequenceLength) {
      final range =
          formattedList.getRange(index, index + sequenceLength).toList();
      if (range.length != 3) break;

      if (!Classifier.isGetter(range[0].member) ||
          range[1].type != ElementType.otherProperty ||
          range[2].type != ElementType.methodPrivate) {
        index++;
        continue;
      }

      final name = range[0].member.declaredElement?.name;
      if (!range[1].member.toString().contains("_${name ?? ''}") ||
          !(range[2].member.declaredElement?.name?.contains('_set') ?? false)) {
        index++;
        continue;
      }

      formattedList.replaceRange(index, index + sequenceLength, [
        MemberData(
            type: ElementType.getterSetterStruct,
            member: range[0].member,
            members: [
              range[0].member,
              range[1].member,
              range[2].member,
            ])
      ]);

      index++;
    }

    return formattedList;
  }
}
