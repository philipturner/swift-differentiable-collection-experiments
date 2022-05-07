// This seems to be **exposed** by RequirementMachine.
//
// This produces the same stack trace when I conform `DifferentiableCollection`
// to `MutableCollection` and `Differentiable`, then substitute the following:
//
// - INVALID_1 -> TangentVector
// - INVALID_2 -> Element
// - INVALID_3 -> Element.TangentVector
//
// Also, one would need to add `import _Differentiation` to this file.
//
// The purpose of invalidating the names is to isolate the bug and help narrow
// down where it happens in the compiler.

protocol DifferentiableCollection
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
  associatedtype ElementTangentCollection: DifferentiableCollection
  where ElementTangentCollection.INVALID_2 == INVALID_3
}

extension DifferentiableCollection {
  typealias DifferentiableView = DifferentiableCollectionView<Self>
}

struct DifferentiableCollectionView<Base: DifferentiableCollection> {}

/*
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:7: error: cannot find type 'INVALID_1' in scope
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
      ^~~~~~~~~
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:1: error: circular reference
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:17:8: note: through reference here
struct DifferentiableCollectionView<Base: DifferentiableCollection> {}
       ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:20: note: while resolving type 'DifferentiableCollectionView<ElementTangentCollection>'
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
                   ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:1: error: circular reference
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:17:8: note: through reference here
struct DifferentiableCollectionView<Base: DifferentiableCollection> {}
       ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:20: note: while resolving type 'DifferentiableCollectionView<ElementTangentCollection>'
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
                   ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:1: error: circular reference
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:17:8: note: through reference here
struct DifferentiableCollectionView<Base: DifferentiableCollection> {}
       ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:8:20: note: while resolving type 'DifferentiableCollectionView<ElementTangentCollection>'
where INVALID_1 == DifferentiableCollectionView<ElementTangentCollection> {
                   ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:10:47: error: cannot find type 'INVALID_3' in scope
  where ElementTangentCollection.INVALID_2 == INVALID_3
                                              ^~~~~~~~~
Re-entrant construction of requirement machine for <τ_0_0 where τ_0_0 : DifferentiableCollection>

1.	Apple Swift version 5.6-dev (LLVM 7b20e61dd04138a, Swift 9438cf6b2e83c5f)
2.	Compiling with the current language version
3.	While evaluating request TypeCheckSourceFileRequest(source_file "/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift")
4.	While type-checking 'DifferentiableCollection' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:7:1)
5.	While type-checking 'ElementTangentCollection' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:9:3)
6.	While evaluating request RequirementRequest(Experimentation4.(file).DifferentiableCollection@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:7:10, 0, interface)
7.	While evaluating request ResolveTypeRequest(while resolving type , ElementTangentCollection.INVALID_2, (null))
8.	While building rewrite system for generic signature <τ_0_0 where τ_0_0 : DifferentiableCollection>
9.	While evaluating request ProtocolDependenciesRequest(Experimentation4.(file).DifferentiableCollection@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:7:10)
10.	While evaluating request RequirementSignatureRequest(Experimentation4.(file).DifferentiableCollection@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:7:10)
11.	While evaluating request RequirementRequest(Experimentation4.(file).DifferentiableCollection@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:7:10, 0, structural)
12.	While evaluating request ResolveTypeRequest(while resolving type , DifferentiableCollectionView<ElementTangentCollection>, (null))
13.	While evaluating request GenericSignatureRequest(Experimentation4.(file).DifferentiableCollectionView@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:17:8)
14.	While evaluating request InferredGenericSignatureRequest(Experimentation4, NULL, <Base : DifferentiableCollection>, (SIL generic parameter list), {}, {}, 0)
15.	While checking generic signature <τ_0_0 where τ_0_0 : DifferentiableCollection>
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x00000001051da5c0 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x00000001051d9820 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x00000001051dac24 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x000000010562daa4 swift::rewriting::RewriteContext::getRequirementMachine(swift::CanGenericSignature) (.cold.2) + 0
7  swift-frontend           0x0000000101feedf8 llvm::operator<<(llvm::raw_ostream&, swift::GenericSignature) + 0
8  swift-frontend           0x0000000101f02654 swift::GenericSignatureImpl::isCanonicalTypeInContext(swift::Type) const + 276
9  swift-frontend           0x0000000101f04158 swift::GenericSignature::verify(llvm::ArrayRef<swift::Requirement>) const + 388
10 swift-frontend           0x0000000101f28e08 swift::GenericSignatureBuilder::computeGenericSignature(bool, swift::ProtocolDecl const*) && + 732
11 swift-frontend           0x0000000101f2a758 swift::InferredGenericSignatureRequest::evaluate(swift::Evaluator&, swift::ModuleDecl*, swift::GenericSignatureImpl const*, swift::GenericParamList*, swift::WhereClauseOwner, llvm::SmallVector<swift::Requirement, 2u>, llvm::SmallVector<swift::TypeLoc, 2u>, bool) const::$_69::operator()() const + 832
12 swift-frontend           0x0000000101f2a230 swift::InferredGenericSignatureRequest::evaluate(swift::Evaluator&, swift::ModuleDecl*, swift::GenericSignatureImpl const*, swift::GenericParamList*, swift::WhereClauseOwner, llvm::SmallVector<swift::Requirement, 2u>, llvm::SmallVector<swift::TypeLoc, 2u>, bool) const + 192
13 swift-frontend           0x0000000101af08e0 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::InferredGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::ModuleDecl*, swift::GenericSignatureImpl const*, swift::GenericParamList*, swift::WhereClauseOwner, llvm::SmallVector<swift::Requirement, 2u>, llvm::SmallVector<swift::TypeLoc, 2u>, bool), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul>) const + 204
14 swift-frontend           0x0000000101b2bd24 llvm::Expected<swift::InferredGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::InferredGenericSignatureRequest>(swift::InferredGenericSignatureRequest const&) + 372
15 swift-frontend           0x0000000101b2b9d8 llvm::Expected<swift::InferredGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::InferredGenericSignatureRequest, (void*)0>(swift::InferredGenericSignatureRequest const&) + 1312
16 swift-frontend           0x0000000101b25ee4 swift::InferredGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::InferredGenericSignatureRequest>(swift::Evaluator&, swift::InferredGenericSignatureRequest, swift::InferredGenericSignatureRequest::OutputType) + 44
17 swift-frontend           0x0000000101aa1ab0 swift::GenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericContext*) const + 912
18 swift-frontend           0x0000000101e1132c llvm::Expected<swift::GenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::GenericSignatureRequest>(swift::GenericSignatureRequest const&) + 388
19 swift-frontend           0x0000000101e110c0 llvm::Expected<swift::GenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::GenericSignatureRequest, (void*)0>(swift::GenericSignatureRequest const&) + 140
20 swift-frontend           0x0000000101de8cf0 swift::GenericContext::getGenericSignature() const + 84
21 swift-frontend           0x0000000101b16d78 swift::TypeResolution::applyUnboundGenericArguments(swift::GenericTypeDecl*, swift::Type, swift::SourceLoc, llvm::ArrayRef<swift::Type>) const + 144
22 swift-frontend           0x0000000101b208d4 applyGenericArguments(swift::Type, swift::TypeResolution, swift::GenericParamList*, swift::ComponentIdentTypeRepr*) + 1632
23 swift-frontend           0x0000000101b1ef7c resolveTypeDecl(swift::TypeDecl*, swift::DeclContext*, swift::TypeResolution, swift::GenericParamList*, swift::ComponentIdentTypeRepr*) + 212
24 swift-frontend           0x0000000101b1a8b8 (anonymous namespace)::TypeResolver::resolveIdentifierType(swift::IdentTypeRepr*, swift::TypeResolutionOptions) + 2544
25 swift-frontend           0x0000000101b17ab8 (anonymous namespace)::TypeResolver::resolveType(swift::TypeRepr*, swift::TypeResolutionOptions) + 260
26 swift-frontend           0x0000000101b17880 swift::ResolveTypeRequest::evaluate(swift::Evaluator&, swift::TypeResolution const*, swift::TypeRepr*, swift::GenericParamList*) const + 72
27 swift-frontend           0x0000000101b240dc llvm::Expected<swift::ResolveTypeRequest::OutputType> swift::Evaluator::getResultUncached<swift::ResolveTypeRequest>(swift::ResolveTypeRequest const&) + 252
28 swift-frontend           0x0000000101b17720 swift::ResolveTypeRequest::OutputType swift::evaluateOrDefault<swift::ResolveTypeRequest>(swift::Evaluator&, swift::ResolveTypeRequest, swift::ResolveTypeRequest::OutputType) + 44
29 swift-frontend           0x0000000101b176d4 swift::TypeResolution::resolveType(swift::TypeRepr*, swift::GenericParamList*) const + 68
30 swift-frontend           0x0000000101aa3ab4 swift::RequirementRequest::evaluate(swift::Evaluator&, swift::WhereClauseOwner, unsigned int, swift::TypeResolutionStage) const + 620
31 swift-frontend           0x0000000102032988 llvm::Expected<swift::RequirementRequest::OutputType> swift::Evaluator::getResultUncached<swift::RequirementRequest>(swift::RequirementRequest const&) + 268
32 swift-frontend           0x000000010202fe50 swift::WhereClauseOwner::visitRequirements(swift::TypeResolutionStage, llvm::function_ref<bool (swift::Requirement, swift::RequirementRepr*)>) const && + 280
33 swift-frontend           0x0000000101f18078 swift::GenericSignatureBuilder::expandConformanceRequirement(swift::GenericSignatureBuilder::ResolvedType, swift::ProtocolDecl*, swift::GenericSignatureBuilder::RequirementSource const*, bool) + 240
34 swift-frontend           0x0000000101f19a7c swift::GenericSignatureBuilder::addConformanceRequirement(swift::GenericSignatureBuilder::ResolvedType, swift::ProtocolDecl*, swift::GenericSignatureBuilder::FloatingRequirementSource) + 228
35 swift-frontend           0x0000000101f1aa40 swift::GenericSignatureBuilder::addTypeRequirement(llvm::PointerUnion<swift::GenericSignatureBuilder::PotentialArchetype*, swift::Type>, llvm::PointerUnion<swift::GenericSignatureBuilder::PotentialArchetype*, swift::Type>, swift::GenericSignatureBuilder::FloatingRequirementSource, swift::GenericSignatureBuilder::UnresolvedHandlingKind, swift::ModuleDecl*) + 1156
36 swift-frontend           0x0000000101f1d0b0 swift::GenericSignatureBuilder::addRequirement(swift::Requirement const&, swift::RequirementRepr const*, swift::GenericSignatureBuilder::FloatingRequirementSource, swift::ModuleDecl*) + 556
37 swift-frontend           0x0000000101f2adec swift::RequirementSignatureRequest::evaluate(swift::Evaluator&, swift::ProtocolDecl*) const::$_71::operator()() const + 336
38 swift-frontend           0x0000000101f2a868 swift::RequirementSignatureRequest::evaluate(swift::Evaluator&, swift::ProtocolDecl*) const + 136
39 swift-frontend           0x0000000101e77b80 llvm::Expected<swift::RequirementSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::RequirementSignatureRequest>(swift::RequirementSignatureRequest const&) + 408
40 swift-frontend           0x0000000101e7790c llvm::Expected<swift::RequirementSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::RequirementSignatureRequest, (void*)0>(swift::RequirementSignatureRequest const&) + 136
41 swift-frontend           0x0000000101dfb478 swift::RequirementSignatureRequest::OutputType swift::evaluateOrDefault<swift::RequirementSignatureRequest>(swift::Evaluator&, swift::RequirementSignatureRequest, swift::RequirementSignatureRequest::OutputType) + 56
42 swift-frontend           0x0000000101fe328c swift::ProtocolDependenciesRequest::evaluate(swift::Evaluator&, swift::ProtocolDecl*) const + 280
43 swift-frontend           0x0000000101e758c4 llvm::Expected<swift::ProtocolDependenciesRequest::OutputType> swift::Evaluator::getResultUncached<swift::ProtocolDependenciesRequest>(swift::ProtocolDependenciesRequest const&) + 408
44 swift-frontend           0x0000000101e755a8 llvm::Expected<swift::ProtocolDependenciesRequest::OutputType> swift::Evaluator::getResultCached<swift::ProtocolDependenciesRequest, (void*)0>(swift::ProtocolDependenciesRequest const&) + 376
45 swift-frontend           0x0000000101dfb2d4 swift::ProtocolDependenciesRequest::OutputType swift::evaluateOrDefault<swift::ProtocolDependenciesRequest>(swift::Evaluator&, swift::ProtocolDependenciesRequest, swift::ProtocolDependenciesRequest::OutputType) + 56
46 swift-frontend           0x0000000101fe38b4 swift::rewriting::RuleBuilder::collectRulesFromReferencedProtocols() + 108
47 swift-frontend           0x0000000101fe3690 swift::rewriting::RuleBuilder::addRequirements(llvm::ArrayRef<swift::Requirement>) + 120
48 swift-frontend           0x0000000101fe8084 swift::rewriting::RequirementMachine::initWithGenericSignature(swift::CanGenericSignature) + 692
49 swift-frontend           0x0000000101feedc8 swift::rewriting::RewriteContext::getRequirementMachine(swift::CanGenericSignature) + 240
50 swift-frontend           0x0000000101f02f7c swift::GenericSignatureImpl::lookupNestedType(swift::Type, swift::Identifier) const + 420
51 swift-frontend           0x0000000101b15514 swift::TypeResolution::resolveDependentMemberType(swift::Type, swift::DeclContext*, swift::SourceRange, swift::ComponentIdentTypeRepr*) const + 212
52 swift-frontend           0x0000000101b1a2c4 (anonymous namespace)::TypeResolver::resolveIdentifierType(swift::IdentTypeRepr*, swift::TypeResolutionOptions) + 1020
53 swift-frontend           0x0000000101b17ab8 (anonymous namespace)::TypeResolver::resolveType(swift::TypeRepr*, swift::TypeResolutionOptions) + 260
54 swift-frontend           0x0000000101b17880 swift::ResolveTypeRequest::evaluate(swift::Evaluator&, swift::TypeResolution const*, swift::TypeRepr*, swift::GenericParamList*) const + 72
55 swift-frontend           0x0000000101b240dc llvm::Expected<swift::ResolveTypeRequest::OutputType> swift::Evaluator::getResultUncached<swift::ResolveTypeRequest>(swift::ResolveTypeRequest const&) + 252
56 swift-frontend           0x0000000101b17720 swift::ResolveTypeRequest::OutputType swift::evaluateOrDefault<swift::ResolveTypeRequest>(swift::Evaluator&, swift::ResolveTypeRequest, swift::ResolveTypeRequest::OutputType) + 44
57 swift-frontend           0x0000000101b176d4 swift::TypeResolution::resolveType(swift::TypeRepr*, swift::GenericParamList*) const + 68
58 swift-frontend           0x0000000101aa3a84 swift::RequirementRequest::evaluate(swift::Evaluator&, swift::WhereClauseOwner, unsigned int, swift::TypeResolutionStage) const + 572
59 swift-frontend           0x0000000102032988 llvm::Expected<swift::RequirementRequest::OutputType> swift::Evaluator::getResultUncached<swift::RequirementRequest>(swift::RequirementRequest const&) + 268
60 swift-frontend           0x000000010203272c llvm::Expected<swift::RequirementRequest::OutputType> swift::Evaluator::getResultCached<swift::RequirementRequest, (void*)0>(swift::RequirementRequest const&) + 484
61 swift-frontend           0x000000010202fe48 swift::WhereClauseOwner::visitRequirements(swift::TypeResolutionStage, llvm::function_ref<bool (swift::Requirement, swift::RequirementRepr*)>) const && + 272
62 swift-frontend           0x0000000101a80c68 swift::ASTVisitor<(anonymous namespace)::DeclChecker, void, void, void, void, void, void>::visit(swift::Decl*) + 2804
63 swift-frontend           0x0000000101a7cd6c (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
64 swift-frontend           0x0000000101a80b68 swift::ASTVisitor<(anonymous namespace)::DeclChecker, void, void, void, void, void, void>::visit(swift::Decl*) + 2548
65 swift-frontend           0x0000000101a7cd6c (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
66 swift-frontend           0x0000000101a7cc78 swift::TypeChecker::typeCheckDecl(swift::Decl*, bool) + 116
67 swift-frontend           0x0000000101b25698 swift::TypeCheckSourceFileRequest::evaluate(swift::Evaluator&, swift::SourceFile*) const + 176
68 swift-frontend           0x0000000101b27454 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultUncached<swift::TypeCheckSourceFileRequest>(swift::TypeCheckSourceFileRequest const&) + 400
69 swift-frontend           0x0000000101b271f4 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultCached<swift::TypeCheckSourceFileRequest, (void*)0>(swift::TypeCheckSourceFileRequest const&) + 124
70 swift-frontend           0x0000000101b254dc swift::TypeCheckSourceFileRequest::OutputType swift::evaluateOrDefault<swift::TypeCheckSourceFileRequest>(swift::Evaluator&, swift::TypeCheckSourceFileRequest, swift::TypeCheckSourceFileRequest::OutputType) + 44
71 swift-frontend           0x0000000100ecdf8c bool llvm::function_ref<bool (swift::SourceFile&)>::callback_fn<swift::CompilerInstance::performSema()::$_6>(long, swift::SourceFile&) + 16
72 swift-frontend           0x0000000100eca8cc swift::CompilerInstance::forEachFileToTypeCheck(llvm::function_ref<bool (swift::SourceFile&)>) + 160
73 swift-frontend           0x0000000100eca800 swift::CompilerInstance::performSema() + 76
74 swift-frontend           0x0000000100e7cfa8 withSemanticAnalysis(swift::CompilerInstance&, swift::FrontendObserver*, llvm::function_ref<bool (swift::CompilerInstance&)>) + 56
75 swift-frontend           0x0000000100e73d08 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 2936
76 swift-frontend           0x0000000100e1213c swift::mainEntry(int, char const**) + 500
77 dyld                     0x000000010d6990f4 start + 520
*/
