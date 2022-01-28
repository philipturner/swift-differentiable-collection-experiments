import _Differentiation

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
1.	Apple Swift version 5.6-dev (LLVM 7b20e61dd04138a, Swift 9438cf6b2e83c5f)
2.	Compiling with the current language version
3.	While evaluating request ExecuteSILPipelineRequest(Run pipelines { Mandatory Diagnostic Passes + Enabling Optimization Passes } on SIL for Experimentation4)
4.	While running pass #16 SILModuleTransform "Differentiation".
5.	While processing // differentiability witness for DifferentiableCollection.differentiableMap<A>(_:)
sil_differentiability_witness [serialized] [reverse] [parameters 1] [results 0] <Self where Self : DifferentiableCollection, Self.Element : Differentiable><Result where Result : Differentiable> @$s16Experimentation424DifferentiableCollectionPAAE17differentiableMapySayqd__Gqd__7ElementQzYjrXE16_Differentiation0B0Rd__AhiGRQlF : $@convention(method) <Self where Self : DifferentiableCollection, Self.Element : Differentiable><Result where Result : Differentiable> (@differentiable(reverse) @noescape @callee_guaranteed @substituted <τ_0_0, τ_0_1> (@in_guaranteed τ_0_0) -> @out τ_0_1 for <Self.Element, Result>, @in_guaranteed Self) -> @owned Array<Result> {
}

 on SIL function "@$s16Experimentation424DifferentiableCollectionPAAE17differentiableMapySayqd__Gqd__7ElementQzYjrXE16_Differentiation0B0Rd__AhiGRQlF".
 for 'differentiableMap(_:)' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:15:3)
6.	While generating VJP for SIL function "@$s16Experimentation424DifferentiableCollectionPAAE17differentiableMapySayqd__Gqd__7ElementQzYjrXE16_Differentiation0B0Rd__AhiGRQlF".
 for 'differentiableMap(_:)' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:15:3)
7.	While generating pullback for SIL function "@$s16Experimentation424DifferentiableCollectionPAAE17differentiableMapySayqd__Gqd__7ElementQzYjrXE16_Differentiation0B0Rd__AhiGRQlF".
 for 'differentiableMap(_:)' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:15:3)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x000000010860e5c0 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x000000010860d820 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x000000010860ec24 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  libsystem_c.dylib        0x00000001bb45572c err + 0
7  swift-frontend           0x00000001087c3344 swift::autodiff::PullbackCloner::Implementation::run() (.cold.21) + 0
8  swift-frontend           0x000000010490dbe4 swift::autodiff::PullbackCloner::Implementation::run() + 7688
9  swift-frontend           0x000000010490bdb0 swift::autodiff::PullbackCloner::run() + 24
10 swift-frontend           0x000000010492794c swift::autodiff::VJPCloner::Implementation::run() + 1368
11 swift-frontend           0x0000000104927f68 swift::autodiff::VJPCloner::run() + 24
12 swift-frontend           0x0000000104a1e2ac (anonymous namespace)::DifferentiationTransformer::canonicalizeDifferentiabilityWitness(swift::SILDifferentiabilityWitness*, swift::autodiff::DifferentiationInvoker, swift::IsSerialized_t) + 5288
13 swift-frontend           0x0000000104a1c3f8 (anonymous namespace)::Differentiation::run() + 924
14 swift-frontend           0x0000000104a89c40 swift::SILPassManager::runModulePass(unsigned int) + 632
15 swift-frontend           0x0000000104a8eff4 swift::SILPassManager::execute() + 628
16 swift-frontend           0x0000000104a86d90 swift::SILPassManager::executePassPipelinePlan(swift::SILPassPipelinePlan const&) + 68
17 swift-frontend           0x0000000104a86d18 swift::ExecuteSILPipelineRequest::evaluate(swift::Evaluator&, swift::SILPipelineExecutionDescriptor) const + 68
18 swift-frontend           0x0000000104aa56e0 swift::SimpleRequest<swift::ExecuteSILPipelineRequest, std::__1::tuple<> (swift::SILPipelineExecutionDescriptor), (swift::RequestFlags)1>::evaluateRequest(swift::ExecuteSILPipelineRequest const&, swift::Evaluator&) + 28
19 swift-frontend           0x0000000104a917bc llvm::Expected<swift::ExecuteSILPipelineRequest::OutputType> swift::Evaluator::getResultUncached<swift::ExecuteSILPipelineRequest>(swift::ExecuteSILPipelineRequest const&) + 252
20 swift-frontend           0x0000000104a86f8c swift::executePassPipelinePlan(swift::SILModule*, swift::SILPassPipelinePlan const&, bool, swift::irgen::IRGenModule*) + 84
21 swift-frontend           0x0000000104a944b0 swift::runSILDiagnosticPasses(swift::SILModule&) + 92
22 swift-frontend           0x00000001042feb34 swift::CompilerInstance::performSILProcessing(swift::SILModule*) + 72
23 swift-frontend           0x00000001042a687c performCompileStepsPostSILGen(swift::CompilerInstance&, std::__1::unique_ptr<swift::SILModule, std::__1::default_delete<swift::SILModule> >, llvm::PointerUnion<swift::ModuleDecl*, swift::SourceFile*>, swift::PrimarySpecificPaths const&, int&, swift::FrontendObserver*) + 620
24 swift-frontend           0x00000001042a60b4 swift::performCompileStepsPostSema(swift::CompilerInstance&, int&, swift::FrontendObserver*) + 540
25 swift-frontend           0x00000001042a7d08 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 2936
26 swift-frontend           0x000000010424613c swift::mainEntry(int, char const**) + 500
27 dyld                     0x0000000110c490f4 start + 520
*/
