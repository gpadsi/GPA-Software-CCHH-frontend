// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persons_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(personsRepository)
final personsRepositoryProvider = PersonsRepositoryProvider._();

final class PersonsRepositoryProvider
    extends
        $FunctionalProvider<
          PersonsRepository,
          PersonsRepository,
          PersonsRepository
        >
    with $Provider<PersonsRepository> {
  PersonsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PersonsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PersonsRepository create(Ref ref) {
    return personsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersonsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersonsRepository>(value),
    );
  }
}

String _$personsRepositoryHash() => r'd6d900e3e4ba8b59adcffeb2116f64d41e2fe4a3';

@ProviderFor(personCatalogs)
final personCatalogsProvider = PersonCatalogsProvider._();

final class PersonCatalogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PersonCatalogs>,
          PersonCatalogs,
          FutureOr<PersonCatalogs>
        >
    with $FutureModifier<PersonCatalogs>, $FutureProvider<PersonCatalogs> {
  PersonCatalogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'personCatalogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personCatalogsHash();

  @$internal
  @override
  $FutureProviderElement<PersonCatalogs> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PersonCatalogs> create(Ref ref) {
    return personCatalogs(ref);
  }
}

String _$personCatalogsHash() => r'9b03c1f8069917df1b19855819548a9e4cd790bc';

@ProviderFor(personsPage)
final personsPageProvider = PersonsPageFamily._();

final class PersonsPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Persona>>,
          ApiPage<Persona>,
          FutureOr<ApiPage<Persona>>
        >
    with $FutureModifier<ApiPage<Persona>>, $FutureProvider<ApiPage<Persona>> {
  PersonsPageProvider._({
    required PersonsPageFamily super.from,
    required int super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'personsPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personsPageHash();

  @override
  String toString() {
    return r'personsPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Persona>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Persona>> create(Ref ref) {
    final argument = this.argument as int;
    return personsPage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonsPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personsPageHash() => r'2ed1e14bcaaeb435f94311c883e501000f91c5e0';

final class PersonsPageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ApiPage<Persona>>, int> {
  PersonsPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'personsPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonsPageProvider call(int pageIndex) =>
      PersonsPageProvider._(argument: pageIndex, from: this);

  @override
  String toString() => r'personsPageProvider';
}

@ProviderFor(personDetail)
final personDetailProvider = PersonDetailFamily._();

final class PersonDetailProvider
    extends $FunctionalProvider<AsyncValue<Persona>, Persona, FutureOr<Persona>>
    with $FutureModifier<Persona>, $FutureProvider<Persona> {
  PersonDetailProvider._({
    required PersonDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'personDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personDetailHash();

  @override
  String toString() {
    return r'personDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Persona> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Persona> create(Ref ref) {
    final argument = this.argument as String;
    return personDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personDetailHash() => r'6c67d29918c5d0e64fb6ffe8f8bbb6c899d5591d';

final class PersonDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Persona>, String> {
  PersonDetailFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'personDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonDetailProvider call(String id) =>
      PersonDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'personDetailProvider';
}

@ProviderFor(contactosDePersona)
final contactosDePersonaProvider = ContactosDePersonaFamily._();

final class ContactosDePersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ContactoUrgencia>>,
          List<ContactoUrgencia>,
          FutureOr<List<ContactoUrgencia>>
        >
    with
        $FutureModifier<List<ContactoUrgencia>>,
        $FutureProvider<List<ContactoUrgencia>> {
  ContactosDePersonaProvider._({
    required ContactosDePersonaFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'contactosDePersonaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contactosDePersonaHash();

  @override
  String toString() {
    return r'contactosDePersonaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ContactoUrgencia>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ContactoUrgencia>> create(Ref ref) {
    final argument = this.argument as String;
    return contactosDePersona(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactosDePersonaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contactosDePersonaHash() =>
    r'bf00b49ee592e9386339d000b92bde0af5d669f8';

final class ContactosDePersonaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ContactoUrgencia>>, String> {
  ContactosDePersonaFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'contactosDePersonaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContactosDePersonaProvider call(String personaId) =>
      ContactosDePersonaProvider._(argument: personaId, from: this);

  @override
  String toString() => r'contactosDePersonaProvider';
}

@ProviderFor(perfilMedicoDePersona)
final perfilMedicoDePersonaProvider = PerfilMedicoDePersonaFamily._();

final class PerfilMedicoDePersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<PerfilMedico?>,
          PerfilMedico?,
          FutureOr<PerfilMedico?>
        >
    with $FutureModifier<PerfilMedico?>, $FutureProvider<PerfilMedico?> {
  PerfilMedicoDePersonaProvider._({
    required PerfilMedicoDePersonaFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'perfilMedicoDePersonaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$perfilMedicoDePersonaHash();

  @override
  String toString() {
    return r'perfilMedicoDePersonaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PerfilMedico?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PerfilMedico?> create(Ref ref) {
    final argument = this.argument as String;
    return perfilMedicoDePersona(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PerfilMedicoDePersonaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$perfilMedicoDePersonaHash() =>
    r'942bea5bd0dc5a08f0a8fb2ce8a2252caead1971';

final class PerfilMedicoDePersonaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PerfilMedico?>, String> {
  PerfilMedicoDePersonaFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'perfilMedicoDePersonaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PerfilMedicoDePersonaProvider call(String personaId) =>
      PerfilMedicoDePersonaProvider._(argument: personaId, from: this);

  @override
  String toString() => r'perfilMedicoDePersonaProvider';
}
