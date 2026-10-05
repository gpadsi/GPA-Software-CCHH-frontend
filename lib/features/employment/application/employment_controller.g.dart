// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(employmentRepository)
final employmentRepositoryProvider = EmploymentRepositoryProvider._();

final class EmploymentRepositoryProvider
    extends
        $FunctionalProvider<
          EmploymentRepository,
          EmploymentRepository,
          EmploymentRepository
        >
    with $Provider<EmploymentRepository> {
  EmploymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmploymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmploymentRepository create(Ref ref) {
    return employmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmploymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmploymentRepository>(value),
    );
  }
}

String _$employmentRepositoryHash() =>
    r'14a9061ce6c987b7ab093412a340b18c2772a7f4';

@ProviderFor(empleadosPage)
final empleadosPageProvider = EmpleadosPageFamily._();

final class EmpleadosPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Empleado>>,
          ApiPage<Empleado>,
          FutureOr<ApiPage<Empleado>>
        >
    with
        $FutureModifier<ApiPage<Empleado>>,
        $FutureProvider<ApiPage<Empleado>> {
  EmpleadosPageProvider._({
    required EmpleadosPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'empleadosPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$empleadosPageHash();

  @override
  String toString() {
    return r'empleadosPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Empleado>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Empleado>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return empleadosPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is EmpleadosPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$empleadosPageHash() => r'547720ffa1c3d1061cfa1a38155bce66a964bada';

final class EmpleadosPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Empleado>>,
          (int, {TableQuery query})
        > {
  EmpleadosPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'empleadosPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EmpleadosPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) =>
      EmpleadosPageProvider._(argument: (pageIndex, query: query), from: this);

  @override
  String toString() => r'empleadosPageProvider';
}

@ProviderFor(empleadoDetail)
final empleadoDetailProvider = EmpleadoDetailFamily._();

final class EmpleadoDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Empleado>, Empleado, FutureOr<Empleado>>
    with $FutureModifier<Empleado>, $FutureProvider<Empleado> {
  EmpleadoDetailProvider._({
    required EmpleadoDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'empleadoDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$empleadoDetailHash();

  @override
  String toString() {
    return r'empleadoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Empleado> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Empleado> create(Ref ref) {
    final argument = this.argument as String;
    return empleadoDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmpleadoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$empleadoDetailHash() => r'ff837e37d73dc78ba9b66ac0f04667d2796f000b';

final class EmpleadoDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Empleado>, String> {
  EmpleadoDetailFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'empleadoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EmpleadoDetailProvider call(String id) =>
      EmpleadoDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'empleadoDetailProvider';
}

@ProviderFor(contratoVigenteDe)
final contratoVigenteDeProvider = ContratoVigenteDeFamily._();

final class ContratoVigenteDeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Contrato?>,
          Contrato?,
          FutureOr<Contrato?>
        >
    with $FutureModifier<Contrato?>, $FutureProvider<Contrato?> {
  ContratoVigenteDeProvider._({
    required ContratoVigenteDeFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'contratoVigenteDeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contratoVigenteDeHash();

  @override
  String toString() {
    return r'contratoVigenteDeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Contrato?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Contrato?> create(Ref ref) {
    final argument = this.argument as String;
    return contratoVigenteDe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContratoVigenteDeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contratoVigenteDeHash() => r'e1082c1c03174c4d6d1ab790de8dd1da290a4785';

final class ContratoVigenteDeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Contrato?>, String> {
  ContratoVigenteDeFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'contratoVigenteDeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContratoVigenteDeProvider call(String empleadoId) =>
      ContratoVigenteDeProvider._(argument: empleadoId, from: this);

  @override
  String toString() => r'contratoVigenteDeProvider';
}

@ProviderFor(personSummary)
final personSummaryProvider = PersonSummaryFamily._();

final class PersonSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PersonSummary>,
          PersonSummary,
          FutureOr<PersonSummary>
        >
    with $FutureModifier<PersonSummary>, $FutureProvider<PersonSummary> {
  PersonSummaryProvider._({
    required PersonSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'personSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personSummaryHash();

  @override
  String toString() {
    return r'personSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PersonSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PersonSummary> create(Ref ref) {
    final argument = this.argument as String;
    return personSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personSummaryHash() => r'e9f70fe2e3e8fef89e7c04ef1ee9451bb7317f7c';

final class PersonSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PersonSummary>, String> {
  PersonSummaryFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'personSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonSummaryProvider call(String personaId) =>
      PersonSummaryProvider._(argument: personaId, from: this);

  @override
  String toString() => r'personSummaryProvider';
}

@ProviderFor(posicionSummary)
final posicionSummaryProvider = PosicionSummaryFamily._();

final class PosicionSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PosicionSummary>,
          PosicionSummary,
          FutureOr<PosicionSummary>
        >
    with $FutureModifier<PosicionSummary>, $FutureProvider<PosicionSummary> {
  PosicionSummaryProvider._({
    required PosicionSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'posicionSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$posicionSummaryHash();

  @override
  String toString() {
    return r'posicionSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PosicionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PosicionSummary> create(Ref ref) {
    final argument = this.argument as String;
    return posicionSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PosicionSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$posicionSummaryHash() => r'984d9b163c8d62c961f27a214d5bc50e30cfc24e';

final class PosicionSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PosicionSummary>, String> {
  PosicionSummaryFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'posicionSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PosicionSummaryProvider call(String posicionId) =>
      PosicionSummaryProvider._(argument: posicionId, from: this);

  @override
  String toString() => r'posicionSummaryProvider';
}

@ProviderFor(puestoRef)
final puestoRefProvider = PuestoRefFamily._();

final class PuestoRefProvider
    extends
        $FunctionalProvider<AsyncValue<NamedRef>, NamedRef, FutureOr<NamedRef>>
    with $FutureModifier<NamedRef>, $FutureProvider<NamedRef> {
  PuestoRefProvider._({
    required PuestoRefFamily super.from,
    required int super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'puestoRefProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$puestoRefHash();

  @override
  String toString() {
    return r'puestoRefProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NamedRef> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NamedRef> create(Ref ref) {
    final argument = this.argument as int;
    return puestoRef(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PuestoRefProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$puestoRefHash() => r'199bdd3c10733541db01801f4f1d30a6a9f646a3';

final class PuestoRefFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NamedRef>, int> {
  PuestoRefFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'puestoRefProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PuestoRefProvider call(int puestoId) =>
      PuestoRefProvider._(argument: puestoId, from: this);

  @override
  String toString() => r'puestoRefProvider';
}

@ProviderFor(estatusRef)
final estatusRefProvider = EstatusRefFamily._();

final class EstatusRefProvider
    extends
        $FunctionalProvider<AsyncValue<NamedRef>, NamedRef, FutureOr<NamedRef>>
    with $FutureModifier<NamedRef>, $FutureProvider<NamedRef> {
  EstatusRefProvider._({
    required EstatusRefFamily super.from,
    required int super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'estatusRefProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$estatusRefHash();

  @override
  String toString() {
    return r'estatusRefProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NamedRef> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NamedRef> create(Ref ref) {
    final argument = this.argument as int;
    return estatusRef(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EstatusRefProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$estatusRefHash() => r'c6f80f2e671ae95daa85739274882b67b92775ef';

final class EstatusRefFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NamedRef>, int> {
  EstatusRefFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'estatusRefProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EstatusRefProvider call(int estatusId) =>
      EstatusRefProvider._(argument: estatusId, from: this);

  @override
  String toString() => r'estatusRefProvider';
}
