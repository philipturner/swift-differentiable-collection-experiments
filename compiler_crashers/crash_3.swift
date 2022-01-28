protocol DifferentiableCollection:
  MutableCollection & Differentiable & Equatable {}

extension DifferentiableCollection {
  @differentiable(reverse)
  func differentiableMap<Result: Differentiable>(
    _ body: @differentiable(reverse) (Element) -> Result
  ) -> [Result] {
    map(body)
  }
}

/*
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:9:23: error: cannot find type 'Differentiable' in scope
  MutableCollection & Differentiable & Equatable {}
                      ^~~~~~~~~~~~~~
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:14:13: error: '@differentiable' attribute used without importing module '_Differentiation'
    _ body: @differentiable(reverse) (Element) -> Result
            ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:13:34: error: cannot find type 'Differentiable' in scope
  func differentiableMap<Result: Differentiable>(
                                 ^~~~~~~~~~~~~~
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:14:13: error: '@differentiable' attribute used without importing module '_Differentiation'
    _ body: @differentiable(reverse) (Element) -> Result
            ^
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:12:4: error: @differentiable attribute used without importing module '_Differentiation'
  @differentiable(reverse)
  ~^~~~~~~~~~~~~~~~~~~~~~~
Invalid type parameter in getCanonicalTypeInContext()
Original type: (@escaping (τ_0_0.Element) -> τ_1_0) -> Array<τ_1_0>
Simplified term: τ_0_0.[Sequence:Element]
Longest valid prefix: τ_0_0
Prefix type: τ_0_0

Requirement machine for <τ_0_0, τ_1_0 where τ_0_0 : DifferentiableCollection>
Rewrite system: {
- [DifferentiableCollection].[DifferentiableCollection] => [DifferentiableCollection] [permanent]
- [DifferentiableCollection].Element => [DifferentiableCollection:Element] [permanent]
- [DifferentiableCollection].Index => [DifferentiableCollection:Index] [permanent]
- [DifferentiableCollection].SubSequence => [DifferentiableCollection:SubSequence] [permanent]
- [DifferentiableCollection].Iterator => [DifferentiableCollection:Iterator] [permanent]
- [DifferentiableCollection].Indices => [DifferentiableCollection:Indices] [permanent]
- τ_0_0.[DifferentiableCollection] => τ_0_0 [explicit]
- [DifferentiableCollection].[DifferentiableCollection:Element] => [DifferentiableCollection:Element]
- [DifferentiableCollection].[DifferentiableCollection:Index] => [DifferentiableCollection:Index]
- [DifferentiableCollection].[DifferentiableCollection:SubSequence] => [DifferentiableCollection:SubSequence]
- [DifferentiableCollection].[DifferentiableCollection:Iterator] => [DifferentiableCollection:Iterator]
- [DifferentiableCollection].[DifferentiableCollection:Indices] => [DifferentiableCollection:Indices]
- τ_0_0.Element => τ_0_0.[DifferentiableCollection:Element]
- τ_0_0.Index => τ_0_0.[DifferentiableCollection:Index]
- τ_0_0.SubSequence => τ_0_0.[DifferentiableCollection:SubSequence]
- τ_0_0.Iterator => τ_0_0.[DifferentiableCollection:Iterator]
- τ_0_0.Indices => τ_0_0.[DifferentiableCollection:Indices]
}
Rewrite loops: {
}
Property map: {
  τ_0_0 => { conforms_to: [DifferentiableCollection] }
}
Conformance access paths: {
}

1.	Apple Swift version 5.6-dev (LLVM 7b20e61dd04138a, Swift 9438cf6b2e83c5f)
2.	Compiling with the current language version
3.	While evaluating request TypeCheckSourceFileRequest(source_file "/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift")
4.	While type-checking extension of DifferentiableCollection (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:11:1)
5.	While type-checking 'differentiableMap(_:)' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:13:3)
6.	While evaluating request CheckRedeclarationRequest(Experimentation4.(file).DifferentiableCollection extension.differentiableMap@/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:13:8)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000108a8e5c0 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000108a8d820 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000108a8ec24 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x000000010587cb14 swift::Type llvm::function_ref<swift::Type (swift::SubstitutableType*)>::callback_fn<swift::rewriting::RequirementMachine::getCanonicalTypeInContext(swift::Type, swift::ArrayRefView<swift::Type, swift::GenericTypeParamType*, swift::GenericTypeParamType* swift::staticCastHelper<swift::GenericTypeParamType>(swift::Type const&), true>) const::$_0::operator()(swift::Type) const::'lambda'(swift::SubstitutableType*)>(long, swift::SubstitutableType*) + 0
7  swift-frontend           0x00000001058cd7f0 swift::Type::transformRec(llvm::function_ref<llvm::Optional<swift::Type> (swift::TypeBase*)>) const + 104
8  swift-frontend           0x00000001058ce764 swift::Type::transformRec(llvm::function_ref<llvm::Optional<swift::Type> (swift::TypeBase*)>) const + 4060
9  swift-frontend           0x00000001058ce764 swift::Type::transformRec(llvm::function_ref<llvm::Optional<swift::Type> (swift::TypeBase*)>) const + 4060
10 swift-frontend           0x000000010587b10c swift::rewriting::RequirementMachine::getCanonicalTypeInContext(swift::Type, swift::ArrayRefView<swift::Type, swift::GenericTypeParamType*, swift::GenericTypeParamType* swift::staticCastHelper<swift::GenericTypeParamType>(swift::Type const&), true>) const + 56
11 swift-frontend           0x00000001057b6a90 swift::GenericSignatureImpl::getCanonicalTypeInContext(swift::Type) const::$_30::operator()() const + 120
12 swift-frontend           0x00000001057b68d8 swift::GenericSignatureImpl::getCanonicalTypeInContext(swift::Type) const + 332
13 swift-frontend           0x00000001058c263c swift::TypeBase::computeCanonicalType() + 1872
14 swift-frontend           0x00000001056a34d8 swift::ValueDecl::getOverloadSignatureType() const + 864
15 swift-frontend           0x000000010532ded0 swift::CheckRedeclarationRequest::evaluate(swift::Evaluator&, swift::ValueDecl*) const + 672
16 swift-frontend           0x00000001053411d8 llvm::Expected<swift::CheckRedeclarationRequest::OutputType> swift::Evaluator::getResultUncached<swift::CheckRedeclarationRequest>(swift::CheckRedeclarationRequest const&) + 400
17 swift-frontend           0x0000000105340f78 llvm::Expected<swift::CheckRedeclarationRequest::OutputType> swift::Evaluator::getResultCached<swift::CheckRedeclarationRequest, (void*)0>(swift::CheckRedeclarationRequest const&) + 160
18 swift-frontend           0x00000001053369d8 swift::CheckRedeclarationRequest::OutputType swift::evaluateOrDefault<swift::CheckRedeclarationRequest>(swift::Evaluator&, swift::CheckRedeclarationRequest, swift::CheckRedeclarationRequest::OutputType) + 44
19 swift-frontend           0x0000000105330db4 (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 296
20 swift-frontend           0x0000000105335fbc swift::ASTVisitor<(anonymous namespace)::DeclChecker, void, void, void, void, void, void>::visit(swift::Decl*) + 7752
21 swift-frontend           0x0000000105330d6c (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
22 swift-frontend           0x0000000105330c78 swift::TypeChecker::typeCheckDecl(swift::Decl*, bool) + 116
23 swift-frontend           0x00000001053d9698 swift::TypeCheckSourceFileRequest::evaluate(swift::Evaluator&, swift::SourceFile*) const + 176
24 swift-frontend           0x00000001053db454 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultUncached<swift::TypeCheckSourceFileRequest>(swift::TypeCheckSourceFileRequest const&) + 400
25 swift-frontend           0x00000001053db1f4 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultCached<swift::TypeCheckSourceFileRequest, (void*)0>(swift::TypeCheckSourceFileRequest const&) + 124
26 swift-frontend           0x00000001053d94dc swift::TypeCheckSourceFileRequest::OutputType swift::evaluateOrDefault<swift::TypeCheckSourceFileRequest>(swift::Evaluator&, swift::TypeCheckSourceFileRequest, swift::TypeCheckSourceFileRequest::OutputType) + 44
27 swift-frontend           0x0000000104781f8c bool llvm::function_ref<bool (swift::SourceFile&)>::callback_fn<swift::CompilerInstance::performSema()::$_6>(long, swift::SourceFile&) + 16
28 swift-frontend           0x000000010477e878 swift::CompilerInstance::forEachFileToTypeCheck(llvm::function_ref<bool (swift::SourceFile&)>) + 76
29 swift-frontend           0x000000010477e800 swift::CompilerInstance::performSema() + 76
30 swift-frontend           0x0000000104730fa8 withSemanticAnalysis(swift::CompilerInstance&, swift::FrontendObserver*, llvm::function_ref<bool (swift::CompilerInstance&)>) + 56
31 swift-frontend           0x0000000104727d08 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 2936
32 swift-frontend           0x00000001046c613c swift::mainEntry(int, char const**) + 500
33 dyld                     0x0000000110efd0f4 start + 520
*/
