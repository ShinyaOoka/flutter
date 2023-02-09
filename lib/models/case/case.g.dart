// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Case on _Case, Store {
  late final _$eventsAtom = Atom(name: '_Case.events', context: context);

  @override
  ObservableList<CaseEvent> get events {
    _$eventsAtom.reportRead();
    return super.events;
  }

  @override
  set events(ObservableList<CaseEvent> value) {
    _$eventsAtom.reportWrite(value, super.events, () {
      super.events = value;
    });
  }

  late final _$nativeCaseAtom =
      Atom(name: '_Case.nativeCase', context: context);

  @override
  NativeCase? get nativeCase {
    _$nativeCaseAtom.reportRead();
    return super.nativeCase;
  }

  @override
  set nativeCase(NativeCase? value) {
    _$nativeCaseAtom.reportWrite(value, super.nativeCase, () {
      super.nativeCase = value;
    });
  }

  @override
  String toString() {
    return '''
events: ${events},
nativeCase: ${nativeCase}
    ''';
  }
}
