import _Differentiation

protocol DifferentiableCollection: Sequence {}

extension DifferentiableCollection {
  func differentiableMap<Result>(_ body: @differentiable (Element) -> Result) {
    fatalError()
  }
  // replacing the above with this also causes the same crash
//  func differentiableMap<Result>(_ body: @differentiable (Iterator) -> Result) {
//    fatalError()
//  }
}

///////////// Below, there are stack traces for each of the two cases above. They differ in the set of generic requirements.

// STACK TRACE FOR `ELEMENT`

/*
file.swift:20:57: warning: '@differentiable' has been renamed to '@differentiable(reverse)' and will be removed in the next release
  func differentiableMap<Result>(_ body: @differentiable (Element) -> Result) {
                                                        ^
                                                        (reverse)
Term does not conform to protocol: τ_0_0.[Sequence]
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on -requirement-machine-abstract-signatures=on -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift 2fe44170a885d31)
2.	Compiling with the current language version
3.	While evaluating request ASTLoweringRequest(Lowering AST to SIL for module file)
4.	While silgen emitFunction SIL function "@$s4file24DifferentiableCollectionPAAE17differentiableMapyyqd__7ElementQzYjrXE16_Differentiation0B0Rd__AghFRQlF".
 for 'differentiableMap(_:)' (at file.swift:20:3)
5.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, Self.Element : Differentiable})
6.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Element : Differentiable})
7.	While evaluating request AbstractGenericSignatureRequestRQM(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Element : Differentiable})
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000106f05518 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000106f04648 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000106f05b7c SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x00000001074bcfa0 (anonymous namespace)::MinimalConformances::decomposeTermIntoConformanceRuleLeftHandSides(swift::rewriting::MutableTerm, llvm::SmallVectorImpl<unsigned int>&) const (.cold.12) + 0
7  swift-frontend           0x0000000103844c9c llvm::MapVector<unsigned int, llvm::SmallVector<unsigned int, 2u>, llvm::DenseMap<unsigned int, unsigned int, llvm::DenseMapInfo<unsigned int>, llvm::detail::DenseMapPair<unsigned int, unsigned int> >, std::__1::vector<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> >, std::__1::allocator<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> > > > >::operator[](unsigned int const&) + 0
8  swift-frontend           0x0000000103842b88 swift::rewriting::RewriteSystem::computeMinimalConformances(llvm::DenseSet<unsigned int, llvm::DenseMapInfo<unsigned int> >&) + 892
9  swift-frontend           0x000000010383a3f4 swift::rewriting::RewriteSystem::minimizeRewriteSystem() + 348
10 swift-frontend           0x000000010385d2c0 swift::rewriting::RequirementMachine::computeMinimalGenericSignatureRequirements() + 56
11 swift-frontend           0x000000010385d678 swift::AbstractGenericSignatureRequestRQM::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 764
12 swift-frontend           0x00000001032fad90 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequestRQM, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
13 swift-frontend           0x00000001037a1c1c llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequestRQM>(swift::AbstractGenericSignatureRequestRQM const&) + 356
14 swift-frontend           0x00000001037a18fc llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequestRQM, (void*)0>(swift::AbstractGenericSignatureRequestRQM const&) + 1316
15 swift-frontend           0x00000001037a123c swift::AbstractGenericSignatureRequestRQM::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequestRQM>(swift::Evaluator&, swift::AbstractGenericSignatureRequestRQM, swift::AbstractGenericSignatureRequestRQM::OutputType) + 28
16 swift-frontend           0x000000010379a550 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 2544
17 swift-frontend           0x00000001032facb4 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
18 swift-frontend           0x00000001037781a0 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
19 swift-frontend           0x0000000103777ee8 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
20 swift-frontend           0x0000000103776b14 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
21 swift-frontend           0x0000000103799f94 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 1076
22 swift-frontend           0x00000001032facb4 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
23 swift-frontend           0x00000001037781a0 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
24 swift-frontend           0x0000000103777ee8 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
25 swift-frontend           0x0000000103776b14 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
26 swift-frontend           0x0000000103776f1c swift::buildGenericSignature(swift::ASTContext&, swift::GenericSignature, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) + 136
27 swift-frontend           0x00000001026d426c buildDifferentiableGenericSignature(swift::CanGenericSignature, swift::CanType, swift::CanType) + 712
28 swift-frontend           0x00000001026cb70c swift::SILFunctionType::getAutoDiffDerivativeFunctionType(swift::IndexSubset*, swift::IndexSubset*, swift::AutoDiffDerivativeFunctionKind, swift::Lowering::TypeConverter&, llvm::function_ref<swift::ProtocolConformanceRef (swift::CanType, swift::Type, swift::ProtocolDecl*)>, swift::CanGenericSignature, bool, swift::CanType) + 2000
29 swift-frontend           0x000000010275b1b8 (anonymous namespace)::TypeClassifierBase<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*>::getNormalDifferentiableSILFunctionTypeRecursiveProperties(swift::CanTypeWrapper<swift::SILFunctionType>, swift::Lowering::AbstractionPattern) + 184
30 swift-frontend           0x000000010274d474 swift::CanTypeVisitor<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t>::visit(swift::CanType, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t) + 1548
31 swift-frontend           0x000000010274df0c swift::Lowering::TypeConverter::getTypeLoweringForLoweredType(swift::Lowering::AbstractionPattern, swift::CanType, swift::TypeExpansionContext, swift::Lowering::IsTypeExpansionSensitive_t) + 632
32 swift-frontend           0x000000010274ccbc swift::Lowering::TypeConverter::getTypeLowering(swift::Lowering::AbstractionPattern, swift::Type, swift::TypeExpansionContext) + 692
33 swift-frontend           0x0000000102b76460 swift::Lowering::TypeConverter::getLoweredType(swift::Type, swift::TypeExpansionContext) + 144
34 swift-frontend           0x0000000102c1eb9c (anonymous namespace)::EmitBBArguments::visitType(swift::CanType, swift::Lowering::AbstractionPattern, bool) + 84
35 swift-frontend           0x0000000102c1f780 swift::CanTypeVisitor<(anonymous namespace)::EmitBBArguments, swift::Lowering::ManagedValue, swift::Lowering::AbstractionPattern>::visit(swift::CanType, swift::Lowering::AbstractionPattern) + 1628
36 swift-frontend           0x0000000102c1eb28 (anonymous namespace)::ArgumentInitHelper::makeArgument(swift::Type, bool, bool, swift::SILBasicBlock*, swift::SILLocation) + 244
37 swift-frontend           0x0000000102c1e434 (anonymous namespace)::ArgumentInitHelper::emitParam(swift::ParamDecl*) + 648
38 swift-frontend           0x0000000102c1d180 swift::Lowering::SILGenFunction::emitBasicProlog(swift::ParameterList*, swift::ParamDecl*, swift::Type, swift::DeclContext*, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 368
39 swift-frontend           0x0000000102c1c1ec swift::Lowering::SILGenFunction::emitProlog(swift::CaptureInfo, swift::ParameterList*, swift::ParamDecl*, swift::DeclContext*, swift::Type, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 108
40 swift-frontend           0x0000000102be1a70 swift::Lowering::SILGenFunction::emitFunction(swift::FuncDecl*) + 244
41 swift-frontend           0x0000000102b718b8 swift::Lowering::SILGenModule::emitFunctionDefinition(swift::SILDeclRef, swift::SILFunction*) + 6396
42 swift-frontend           0x0000000102b73204 emitOrDelayFunction(swift::Lowering::SILGenModule&, swift::SILDeclRef, bool) + 384
43 swift-frontend           0x0000000102b6ffa4 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 140
44 swift-frontend           0x0000000102c2fd94 SILGenExtension::visitFuncDecl(swift::FuncDecl*) + 160
45 swift-frontend           0x0000000102c2c724 SILGenExtension::emitExtension(swift::ExtensionDecl*) + 68
46 swift-frontend           0x0000000102c2c6d4 swift::Lowering::SILGenModule::visitExtensionDecl(swift::ExtensionDecl*) + 24
47 swift-frontend           0x0000000102b753c4 swift::ASTLoweringRequest::evaluate(swift::Evaluator&, swift::ASTLoweringDescriptor) const + 1696
48 swift-frontend           0x0000000102c20120 swift::SimpleRequest<swift::ASTLoweringRequest, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> > (swift::ASTLoweringDescriptor), (swift::RequestFlags)9>::evaluateRequest(swift::ASTLoweringRequest const&, swift::Evaluator&) + 140
49 swift-frontend           0x0000000102b78f70 llvm::Expected<swift::ASTLoweringRequest::OutputType> swift::Evaluator::getResultUncached<swift::ASTLoweringRequest>(swift::ASTLoweringRequest const&) + 392
50 swift-frontend           0x0000000102b75ed4 swift::performASTLowering(swift::ModuleDecl*, swift::Lowering::TypeConverter&, swift::SILOptions const&) + 128
51 swift-frontend           0x000000010261ac8c swift::performCompileStepsPostSema(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 988
52 swift-frontend           0x000000010261c76c swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
53 swift-frontend           0x0000000102556580 swift::mainEntry(int, char const**) + 484
54 dyld                     0x000000011930d0f4 start + 520
zsh: abort      ../../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift -Xfronten
*/

// STACK TRACE FOR `ITERATOR`

/*
file.swift:20:57: warning: '@differentiable' has been renamed to '@differentiable(reverse)' and will be removed in the next release
  func differentiableMap<Result>(_ body: @differentiable (Iterator) -> Result) {
                                                        ^
                                                        (reverse)
Term does not conform to protocol: τ_0_0.[Sequence]
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on -requirement-machine-abstract-signatures=on -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift 2fe44170a885d31)
2.	Compiling with the current language version
3.	While evaluating request ASTLoweringRequest(Lowering AST to SIL for module file)
4.	While silgen emitFunction SIL function "@$s4file24DifferentiableCollectionPAAE17differentiableMapyyqd__8IteratorQzYjrXE16_Differentiation0B0Rd__AghFRQlF".
 for 'differentiableMap(_:)' (at file.swift:20:3)
5.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, Self.Iterator : IteratorProtocol, Self.Iterator : Differentiable})
6.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Iterator : IteratorProtocol, τ_0_0.Iterator : Differentiable})
7.	While evaluating request AbstractGenericSignatureRequestRQM(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Iterator : IteratorProtocol, τ_0_0.Iterator : Differentiable})
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x000000010536d518 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x000000010536c648 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x000000010536db7c SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x0000000105924fa0 (anonymous namespace)::MinimalConformances::decomposeTermIntoConformanceRuleLeftHandSides(swift::rewriting::MutableTerm, llvm::SmallVectorImpl<unsigned int>&) const (.cold.12) + 0
7  swift-frontend           0x0000000101cacc9c llvm::MapVector<unsigned int, llvm::SmallVector<unsigned int, 2u>, llvm::DenseMap<unsigned int, unsigned int, llvm::DenseMapInfo<unsigned int>, llvm::detail::DenseMapPair<unsigned int, unsigned int> >, std::__1::vector<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> >, std::__1::allocator<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> > > > >::operator[](unsigned int const&) + 0
8  swift-frontend           0x0000000101caab88 swift::rewriting::RewriteSystem::computeMinimalConformances(llvm::DenseSet<unsigned int, llvm::DenseMapInfo<unsigned int> >&) + 892
9  swift-frontend           0x0000000101ca23f4 swift::rewriting::RewriteSystem::minimizeRewriteSystem() + 348
10 swift-frontend           0x0000000101cc52c0 swift::rewriting::RequirementMachine::computeMinimalGenericSignatureRequirements() + 56
11 swift-frontend           0x0000000101cc5678 swift::AbstractGenericSignatureRequestRQM::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 764
12 swift-frontend           0x0000000101762d90 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequestRQM, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
13 swift-frontend           0x0000000101c09c1c llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequestRQM>(swift::AbstractGenericSignatureRequestRQM const&) + 356
14 swift-frontend           0x0000000101c098fc llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequestRQM, (void*)0>(swift::AbstractGenericSignatureRequestRQM const&) + 1316
15 swift-frontend           0x0000000101c0923c swift::AbstractGenericSignatureRequestRQM::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequestRQM>(swift::Evaluator&, swift::AbstractGenericSignatureRequestRQM, swift::AbstractGenericSignatureRequestRQM::OutputType) + 28
16 swift-frontend           0x0000000101c02550 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 2544
17 swift-frontend           0x0000000101762cb4 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
18 swift-frontend           0x0000000101be01a0 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
19 swift-frontend           0x0000000101bdfee8 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
20 swift-frontend           0x0000000101bdeb14 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
21 swift-frontend           0x0000000101c01f94 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 1076
22 swift-frontend           0x0000000101762cb4 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
23 swift-frontend           0x0000000101be01a0 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
24 swift-frontend           0x0000000101bdfee8 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
25 swift-frontend           0x0000000101bdeb14 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
26 swift-frontend           0x0000000101bdef1c swift::buildGenericSignature(swift::ASTContext&, swift::GenericSignature, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) + 136
27 swift-frontend           0x0000000100b3c26c buildDifferentiableGenericSignature(swift::CanGenericSignature, swift::CanType, swift::CanType) + 712
28 swift-frontend           0x0000000100b3370c swift::SILFunctionType::getAutoDiffDerivativeFunctionType(swift::IndexSubset*, swift::IndexSubset*, swift::AutoDiffDerivativeFunctionKind, swift::Lowering::TypeConverter&, llvm::function_ref<swift::ProtocolConformanceRef (swift::CanType, swift::Type, swift::ProtocolDecl*)>, swift::CanGenericSignature, bool, swift::CanType) + 2000
29 swift-frontend           0x0000000100bc31b8 (anonymous namespace)::TypeClassifierBase<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*>::getNormalDifferentiableSILFunctionTypeRecursiveProperties(swift::CanTypeWrapper<swift::SILFunctionType>, swift::Lowering::AbstractionPattern) + 184
30 swift-frontend           0x0000000100bb5474 swift::CanTypeVisitor<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t>::visit(swift::CanType, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t) + 1548
31 swift-frontend           0x0000000100bb5f0c swift::Lowering::TypeConverter::getTypeLoweringForLoweredType(swift::Lowering::AbstractionPattern, swift::CanType, swift::TypeExpansionContext, swift::Lowering::IsTypeExpansionSensitive_t) + 632
32 swift-frontend           0x0000000100bb4cbc swift::Lowering::TypeConverter::getTypeLowering(swift::Lowering::AbstractionPattern, swift::Type, swift::TypeExpansionContext) + 692
33 swift-frontend           0x0000000100fde460 swift::Lowering::TypeConverter::getLoweredType(swift::Type, swift::TypeExpansionContext) + 144
34 swift-frontend           0x0000000101086b9c (anonymous namespace)::EmitBBArguments::visitType(swift::CanType, swift::Lowering::AbstractionPattern, bool) + 84
35 swift-frontend           0x0000000101087780 swift::CanTypeVisitor<(anonymous namespace)::EmitBBArguments, swift::Lowering::ManagedValue, swift::Lowering::AbstractionPattern>::visit(swift::CanType, swift::Lowering::AbstractionPattern) + 1628
36 swift-frontend           0x0000000101086b28 (anonymous namespace)::ArgumentInitHelper::makeArgument(swift::Type, bool, bool, swift::SILBasicBlock*, swift::SILLocation) + 244
37 swift-frontend           0x0000000101086434 (anonymous namespace)::ArgumentInitHelper::emitParam(swift::ParamDecl*) + 648
38 swift-frontend           0x0000000101085180 swift::Lowering::SILGenFunction::emitBasicProlog(swift::ParameterList*, swift::ParamDecl*, swift::Type, swift::DeclContext*, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 368
39 swift-frontend           0x00000001010841ec swift::Lowering::SILGenFunction::emitProlog(swift::CaptureInfo, swift::ParameterList*, swift::ParamDecl*, swift::DeclContext*, swift::Type, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 108
40 swift-frontend           0x0000000101049a70 swift::Lowering::SILGenFunction::emitFunction(swift::FuncDecl*) + 244
41 swift-frontend           0x0000000100fd98b8 swift::Lowering::SILGenModule::emitFunctionDefinition(swift::SILDeclRef, swift::SILFunction*) + 6396
42 swift-frontend           0x0000000100fdb204 emitOrDelayFunction(swift::Lowering::SILGenModule&, swift::SILDeclRef, bool) + 384
43 swift-frontend           0x0000000100fd7fa4 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 140
44 swift-frontend           0x0000000101097d94 SILGenExtension::visitFuncDecl(swift::FuncDecl*) + 160
45 swift-frontend           0x0000000101094724 SILGenExtension::emitExtension(swift::ExtensionDecl*) + 68
46 swift-frontend           0x00000001010946d4 swift::Lowering::SILGenModule::visitExtensionDecl(swift::ExtensionDecl*) + 24
47 swift-frontend           0x0000000100fdd3c4 swift::ASTLoweringRequest::evaluate(swift::Evaluator&, swift::ASTLoweringDescriptor) const + 1696
48 swift-frontend           0x0000000101088120 swift::SimpleRequest<swift::ASTLoweringRequest, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> > (swift::ASTLoweringDescriptor), (swift::RequestFlags)9>::evaluateRequest(swift::ASTLoweringRequest const&, swift::Evaluator&) + 140
49 swift-frontend           0x0000000100fe0f70 llvm::Expected<swift::ASTLoweringRequest::OutputType> swift::Evaluator::getResultUncached<swift::ASTLoweringRequest>(swift::ASTLoweringRequest const&) + 392
50 swift-frontend           0x0000000100fdded4 swift::performASTLowering(swift::ModuleDecl*, swift::Lowering::TypeConverter&, swift::SILOptions const&) + 128
51 swift-frontend           0x0000000100a82c8c swift::performCompileStepsPostSema(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 988
52 swift-frontend           0x0000000100a8476c swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
53 swift-frontend           0x00000001009be580 swift::mainEntry(int, char const**) + 484
54 dyld                     0x00000001176990f4 start + 520
zsh: abort      ../../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift -Xfronten
*/
