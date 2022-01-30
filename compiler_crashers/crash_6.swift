import _Differentiation

public protocol DifferentiableCollection: Sequence {}

extension DifferentiableCollection {
  func differentiableMap<Result>(
    _ body: @differentiable (Element) -> Result
  ) {
    fatalError()
  }
}

/*
file.swift:19:28: warning: '@differentiable' has been renamed to '@differentiable(reverse)' and will be removed in the next release
    _ body: @differentiable (Element) -> Result
                           ^
                           (reverse)
Term does not conform to protocol: τ_0_0.[Sequence]
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on -requirement-machine-abstract-signatures=on -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift d6f6edf0712b0c1)
2.	Compiling with the current language version
3.	While evaluating request ASTLoweringRequest(Lowering AST to SIL for module file)
4.	While silgen emitFunction SIL function "@$s4file24DifferentiableCollectionPAAE17differentiableMapyyqd__7ElementQzYjrXE16_Differentiation0B0Rd__AghFRQlF".
 for 'differentiableMap(_:)' (at file.swift:18:3)
5.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, Self.Element : Differentiable})
6.	While evaluating request AbstractGenericSignatureRequest(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Element : Differentiable})
7.	While evaluating request AbstractGenericSignatureRequestRQM(<τ_0_0, τ_0_1>, {}, {τ_0_0 : Differentiable, τ_0_0.Element : Differentiable})
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000109342314 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000109341444 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000109342978 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x00000001098f8bb0 (anonymous namespace)::MinimalConformances::decomposeTermIntoConformanceRuleLeftHandSides(swift::rewriting::MutableTerm, llvm::SmallVectorImpl<unsigned int>&) const (.cold.12) + 0
7  swift-frontend           0x0000000105c81e4c llvm::MapVector<unsigned int, llvm::SmallVector<unsigned int, 2u>, llvm::DenseMap<unsigned int, unsigned int, llvm::DenseMapInfo<unsigned int>, llvm::detail::DenseMapPair<unsigned int, unsigned int> >, std::__1::vector<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> >, std::__1::allocator<std::__1::pair<unsigned int, llvm::SmallVector<unsigned int, 2u> > > > >::operator[](unsigned int const&) + 0
8  swift-frontend           0x0000000105c7fd38 swift::rewriting::RewriteSystem::computeMinimalConformances(llvm::DenseSet<unsigned int, llvm::DenseMapInfo<unsigned int> >&) + 892
9  swift-frontend           0x0000000105c775a4 swift::rewriting::RewriteSystem::minimizeRewriteSystem() + 348
10 swift-frontend           0x0000000105c9a470 swift::rewriting::RequirementMachine::computeMinimalGenericSignatureRequirements() + 56
11 swift-frontend           0x0000000105c9a828 swift::AbstractGenericSignatureRequestRQM::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 764
12 swift-frontend           0x000000010573804c llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequestRQM, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
13 swift-frontend           0x0000000105bdedcc llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequestRQM>(swift::AbstractGenericSignatureRequestRQM const&) + 356
14 swift-frontend           0x0000000105bdeaac llvm::Expected<swift::AbstractGenericSignatureRequestRQM::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequestRQM, (void*)0>(swift::AbstractGenericSignatureRequestRQM const&) + 1316
15 swift-frontend           0x0000000105bde3ec swift::AbstractGenericSignatureRequestRQM::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequestRQM>(swift::Evaluator&, swift::AbstractGenericSignatureRequestRQM, swift::AbstractGenericSignatureRequestRQM::OutputType) + 28
16 swift-frontend           0x0000000105bd7700 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 2544
17 swift-frontend           0x0000000105737f70 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
18 swift-frontend           0x0000000105bb5350 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
19 swift-frontend           0x0000000105bb5098 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
20 swift-frontend           0x0000000105bb3cc4 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
21 swift-frontend           0x0000000105bd7144 swift::AbstractGenericSignatureRequest::evaluate(swift::Evaluator&, swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) const + 1076
22 swift-frontend           0x0000000105737f70 llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > swift::SimpleRequest<swift::AbstractGenericSignatureRequest, llvm::PointerIntPair<swift::GenericSignature, 1u, unsigned int, llvm::PointerLikeTypeTraits<swift::GenericSignature>, llvm::PointerIntPairInfo<swift::GenericSignature, 1u, llvm::PointerLikeTypeTraits<swift::GenericSignature> > > (swift::GenericSignatureImpl const*, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>), (swift::RequestFlags)2>::callDerived<0ul, 1ul, 2ul>(swift::Evaluator&, std::__1::integer_sequence<unsigned long, 0ul, 1ul, 2ul>) const + 148
23 swift-frontend           0x0000000105bb5350 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultUncached<swift::AbstractGenericSignatureRequest>(swift::AbstractGenericSignatureRequest const&) + 252
24 swift-frontend           0x0000000105bb5098 llvm::Expected<swift::AbstractGenericSignatureRequest::OutputType> swift::Evaluator::getResultCached<swift::AbstractGenericSignatureRequest, (void*)0>(swift::AbstractGenericSignatureRequest const&) + 1316
25 swift-frontend           0x0000000105bb3cc4 swift::AbstractGenericSignatureRequest::OutputType swift::evaluateOrDefault<swift::AbstractGenericSignatureRequest>(swift::Evaluator&, swift::AbstractGenericSignatureRequest, swift::AbstractGenericSignatureRequest::OutputType) + 28
26 swift-frontend           0x0000000105bb40cc swift::buildGenericSignature(swift::ASTContext&, swift::GenericSignature, llvm::SmallVector<swift::GenericTypeParamType*, 2u>, llvm::SmallVector<swift::Requirement, 2u>) + 136
27 swift-frontend           0x0000000104b18db0 buildDifferentiableGenericSignature(swift::CanGenericSignature, swift::CanType, swift::CanType) + 712
28 swift-frontend           0x0000000104b10250 swift::SILFunctionType::getAutoDiffDerivativeFunctionType(swift::IndexSubset*, swift::IndexSubset*, swift::AutoDiffDerivativeFunctionKind, swift::Lowering::TypeConverter&, llvm::function_ref<swift::ProtocolConformanceRef (swift::CanType, swift::Type, swift::ProtocolDecl*)>, swift::CanGenericSignature, bool, swift::CanType) + 2000
29 swift-frontend           0x0000000104b9fa5c (anonymous namespace)::TypeClassifierBase<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*>::getNormalDifferentiableSILFunctionTypeRecursiveProperties(swift::CanTypeWrapper<swift::SILFunctionType>, swift::Lowering::AbstractionPattern) + 184
30 swift-frontend           0x0000000104b91d54 swift::CanTypeVisitor<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t>::visit(swift::CanType, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t) + 1548
31 swift-frontend           0x0000000104b927ec swift::Lowering::TypeConverter::getTypeLoweringForLoweredType(swift::Lowering::AbstractionPattern, swift::CanType, swift::TypeExpansionContext, swift::Lowering::IsTypeExpansionSensitive_t) + 632
32 swift-frontend           0x0000000104b9159c swift::Lowering::TypeConverter::getTypeLowering(swift::Lowering::AbstractionPattern, swift::Type, swift::TypeExpansionContext) + 692
33 swift-frontend           0x0000000104fb9b64 swift::Lowering::TypeConverter::getLoweredType(swift::Type, swift::TypeExpansionContext) + 144
34 swift-frontend           0x000000010506218c (anonymous namespace)::EmitBBArguments::visitType(swift::CanType, swift::Lowering::AbstractionPattern, bool) + 84
35 swift-frontend           0x0000000105062d70 swift::CanTypeVisitor<(anonymous namespace)::EmitBBArguments, swift::Lowering::ManagedValue, swift::Lowering::AbstractionPattern>::visit(swift::CanType, swift::Lowering::AbstractionPattern) + 1628
36 swift-frontend           0x0000000105062118 (anonymous namespace)::ArgumentInitHelper::makeArgument(swift::Type, bool, bool, swift::SILBasicBlock*, swift::SILLocation) + 244
37 swift-frontend           0x0000000105061ac0 (anonymous namespace)::ArgumentInitHelper::emitParam(swift::ParamDecl*) + 648
38 swift-frontend           0x000000010506080c swift::Lowering::SILGenFunction::emitBasicProlog(swift::ParameterList*, swift::ParamDecl*, swift::Type, swift::DeclContext*, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 368
39 swift-frontend           0x000000010505f878 swift::Lowering::SILGenFunction::emitProlog(swift::CaptureInfo, swift::ParameterList*, swift::ParamDecl*, swift::DeclContext*, swift::Type, bool, swift::SourceLoc, llvm::Optional<swift::Lowering::AbstractionPattern>) + 108
40 swift-frontend           0x00000001050250fc swift::Lowering::SILGenFunction::emitFunction(swift::FuncDecl*) + 244
41 swift-frontend           0x0000000104fb4fbc swift::Lowering::SILGenModule::emitFunctionDefinition(swift::SILDeclRef, swift::SILFunction*) + 6396
42 swift-frontend           0x0000000104fb6908 emitOrDelayFunction(swift::Lowering::SILGenModule&, swift::SILDeclRef, bool) + 384
43 swift-frontend           0x0000000104fb36a8 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 140
44 swift-frontend           0x0000000105073384 SILGenExtension::visitFuncDecl(swift::FuncDecl*) + 160
45 swift-frontend           0x000000010506fd14 SILGenExtension::emitExtension(swift::ExtensionDecl*) + 68
46 swift-frontend           0x000000010506fcc4 swift::Lowering::SILGenModule::visitExtensionDecl(swift::ExtensionDecl*) + 24
47 swift-frontend           0x0000000104fb8ac8 swift::ASTLoweringRequest::evaluate(swift::Evaluator&, swift::ASTLoweringDescriptor) const + 1696
48 swift-frontend           0x0000000105063710 swift::SimpleRequest<swift::ASTLoweringRequest, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> > (swift::ASTLoweringDescriptor), (swift::RequestFlags)9>::evaluateRequest(swift::ASTLoweringRequest const&, swift::Evaluator&) + 140
49 swift-frontend           0x0000000104fbc674 llvm::Expected<swift::ASTLoweringRequest::OutputType> swift::Evaluator::getResultUncached<swift::ASTLoweringRequest>(swift::ASTLoweringRequest const&) + 392
50 swift-frontend           0x0000000104fb95d8 swift::performASTLowering(swift::ModuleDecl*, swift::Lowering::TypeConverter&, swift::SILOptions const&) + 128
51 swift-frontend           0x0000000104a5f7f4 swift::performCompileStepsPostSema(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 988
52 swift-frontend           0x0000000104a612d4 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
53 swift-frontend           0x000000010499b108 swift::mainEntry(int, char const**) + 484
54 dyld                     0x000000011b5bd0f4 start + 520
zsh: abort      ../../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift -Xfronten
*/
