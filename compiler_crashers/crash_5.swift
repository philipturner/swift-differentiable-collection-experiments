import _Differentiation

protocol DifferentiableCollection: Sequence {}

extension DifferentiableCollection {
  func differentiableMap(_ body: @differentiable (Void) -> Void) {
    fatalError()
  }
}


/*
file.swift:20:49: warning: '@differentiable' has been renamed to '@differentiable(reverse)' and will be removed in the next release
  func differentiableMap(_ body: @differentiable (Void) -> Void) {
                                                ^
                                                (reverse)
file.swift:20:50: warning: when calling this function in Swift 4 or later, you must pass a '()' tuple; did you mean for the input type to be '()'?
  func differentiableMap(_ body: @differentiable (Void) -> Void) {
                                                 ^~~~~~
                                                 ()
Assertion failed: (!parameterIndices->isEmpty() && "Parameter indices must not be empty"), function getAutoDiffDerivativeFunctionType, file SILFunctionType.cpp, line 812.
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on -requirement-machine-abstract-signatures=on -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift 2fe44170a885d31)
2.	Compiling with the current language version
3.	While evaluating request ASTLoweringRequest(Lowering AST to SIL for module file)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x00000001095f9518 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x00000001095f8648 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x00000001095f9b7c SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  libsystem_c.dylib        0x00000001bb45572c err + 0
7  swift-frontend           0x0000000109623ee4 swift::SILFunctionType::getAutoDiffDerivativeFunctionType(swift::IndexSubset*, swift::IndexSubset*, swift::AutoDiffDerivativeFunctionKind, swift::Lowering::TypeConverter&, llvm::function_ref<swift::ProtocolConformanceRef (swift::CanType, swift::Type, swift::ProtocolDecl*)>, swift::CanGenericSignature, bool, swift::CanType) (.cold.3) + 0
8  swift-frontend           0x0000000104dbefc4 swift::SILFunctionType::getAutoDiffDerivativeFunctionType(swift::IndexSubset*, swift::IndexSubset*, swift::AutoDiffDerivativeFunctionKind, swift::Lowering::TypeConverter&, llvm::function_ref<swift::ProtocolConformanceRef (swift::CanType, swift::Type, swift::ProtocolDecl*)>, swift::CanGenericSignature, bool, swift::CanType) + 136
9  swift-frontend           0x0000000104e4f1b8 (anonymous namespace)::TypeClassifierBase<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*>::getNormalDifferentiableSILFunctionTypeRecursiveProperties(swift::CanTypeWrapper<swift::SILFunctionType>, swift::Lowering::AbstractionPattern) + 184
10 swift-frontend           0x0000000104e41474 swift::CanTypeVisitor<(anonymous namespace)::LowerType, swift::Lowering::TypeLowering*, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t>::visit(swift::CanType, swift::Lowering::AbstractionPattern, swift::Lowering::IsTypeExpansionSensitive_t) + 1548
11 swift-frontend           0x0000000104e41f0c swift::Lowering::TypeConverter::getTypeLoweringForLoweredType(swift::Lowering::AbstractionPattern, swift::CanType, swift::TypeExpansionContext, swift::Lowering::IsTypeExpansionSensitive_t) + 632
12 swift-frontend           0x0000000104e40cbc swift::Lowering::TypeConverter::getTypeLowering(swift::Lowering::AbstractionPattern, swift::Type, swift::TypeExpansionContext) + 692
13 swift-frontend           0x0000000104dcb11c (anonymous namespace)::DestructureInputs::visit(swift::ValueOwnership, bool, swift::Lowering::AbstractionPattern, swift::CanType, bool, bool) + 184
14 swift-frontend           0x0000000104dc9668 getSILFunctionType(swift::Lowering::TypeConverter&, swift::TypeExpansionContext, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::AnyFunctionType>, swift::SILExtInfoBuilder, (anonymous namespace)::Conventions const&, swift::ForeignInfo const&, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SubstitutionMap>, swift::ProtocolConformanceRef, llvm::Optional<llvm::SmallBitVector>) + 2560
15 swift-frontend           0x0000000104dc8bfc getNativeSILFunctionType(swift::Lowering::TypeConverter&, swift::TypeExpansionContext, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::AnyFunctionType>, swift::SILExtInfoBuilder, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SubstitutionMap>, swift::ProtocolConformanceRef, llvm::Optional<llvm::SmallBitVector>)::$_12::operator()((anonymous namespace)::Conventions const&) const + 316
16 swift-frontend           0x0000000104dc2214 getNativeSILFunctionType(swift::Lowering::TypeConverter&, swift::TypeExpansionContext, swift::Lowering::AbstractionPattern, swift::CanTypeWrapper<swift::AnyFunctionType>, swift::SILExtInfoBuilder, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SILDeclRef>, llvm::Optional<swift::SubstitutionMap>, swift::ProtocolConformanceRef, llvm::Optional<llvm::SmallBitVector>) + 484
17 swift-frontend           0x0000000104dc37bc getUncachedSILFunctionTypeForConstant(swift::Lowering::TypeConverter&, swift::TypeExpansionContext, swift::SILDeclRef, swift::Lowering::TypeConverter::LoweredFormalTypes) + 1920
18 swift-frontend           0x0000000104dc40e0 swift::Lowering::TypeConverter::getConstantInfo(swift::TypeExpansionContext, swift::SILDeclRef) + 200
19 swift-frontend           0x0000000104dbc50c swift::SILFunctionBuilder::getOrCreateFunction(swift::SILLocation, swift::SILDeclRef, swift::ForDefinition_t, llvm::function_ref<swift::SILFunction* (swift::SILLocation, swift::SILDeclRef)>, swift::ProfileCounter) + 132
20 swift-frontend           0x0000000105263898 swift::Lowering::SILGenModule::getFunction(swift::SILDeclRef, swift::ForDefinition_t) + 328
21 swift-frontend           0x00000001052671dc emitOrDelayFunction(swift::Lowering::SILGenModule&, swift::SILDeclRef, bool) + 344
22 swift-frontend           0x0000000105263fa4 swift::Lowering::SILGenModule::emitFunction(swift::FuncDecl*) + 140
23 swift-frontend           0x0000000105323d94 SILGenExtension::visitFuncDecl(swift::FuncDecl*) + 160
24 swift-frontend           0x0000000105320724 SILGenExtension::emitExtension(swift::ExtensionDecl*) + 68
25 swift-frontend           0x00000001053206d4 swift::Lowering::SILGenModule::visitExtensionDecl(swift::ExtensionDecl*) + 24
26 swift-frontend           0x00000001052693c4 swift::ASTLoweringRequest::evaluate(swift::Evaluator&, swift::ASTLoweringDescriptor) const + 1696
27 swift-frontend           0x0000000105314120 swift::SimpleRequest<swift::ASTLoweringRequest, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> > (swift::ASTLoweringDescriptor), (swift::RequestFlags)9>::evaluateRequest(swift::ASTLoweringRequest const&, swift::Evaluator&) + 140
28 swift-frontend           0x000000010526cf70 llvm::Expected<swift::ASTLoweringRequest::OutputType> swift::Evaluator::getResultUncached<swift::ASTLoweringRequest>(swift::ASTLoweringRequest const&) + 392
29 swift-frontend           0x0000000105269ed4 swift::performASTLowering(swift::ModuleDecl*, swift::Lowering::TypeConverter&, swift::SILOptions const&) + 128
30 swift-frontend           0x0000000104d0ec8c swift::performCompileStepsPostSema(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 988
31 swift-frontend           0x0000000104d1076c swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
32 swift-frontend           0x0000000104c4a580 swift::mainEntry(int, char const**) + 484
33 dyld                     0x000000011b70d0f4 start + 520
zsh: abort      ../../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift -Xfronten
*/
