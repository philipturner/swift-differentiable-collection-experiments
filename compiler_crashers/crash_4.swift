import _Differentiation

public protocol DifferentiableCollection: Collection, Differentiable
where
  Element: Differentiable,
  TangentVector == ElementTangentCollection.DifferentiableView
{
  associatedtype DifferentiableView: DifferentiableCollectionViewProtocol
  associatedtype ElementTangentCollection: DifferentiableCollection
}

public protocol DifferentiableCollectionViewProtocol: DifferentiableCollection {
  associatedtype Base: DifferentiableCollection
}

public struct DifferentiableCollectionView<Base: DifferentiableCollection>:
  DifferentiableCollectionViewProtocol {}

/*
Right hand side does not have a canonical parent: same_type: τ_0_0.Base.TangentVector τ_0_0.Base.ElementTangentCollection.DifferentiableView.TangentVector
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift d6f6edf0712b0c1)
2.	Compiling with the current language version
3.	While evaluating request TypeCheckSourceFileRequest(source_file "file.swift")
4.	While type-checking 'DifferentiableCollectionViewProtocol' (at file.swift:12:8)
5.	While checking generic signature <τ_0_0 where τ_0_0 : DifferentiableCollectionViewProtocol>
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000104d9e314 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000104d9d444 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000104d9e978 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  swift-frontend           0x00000001053232b4 swift::GenericSignature::verify(llvm::ArrayRef<swift::Requirement>) const (.cold.42) + 0
7  swift-frontend           0x000000010160f39c swift::GenericSignature::verify(llvm::ArrayRef<swift::Requirement>) const + 2448
8  swift-frontend           0x000000010111ffdc swift::ASTVisitor<(anonymous namespace)::DeclChecker, void, void, void, void, void, void>::visit(swift::Decl*) + 5572
9  swift-frontend           0x000000010111b648 (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
10 swift-frontend           0x000000010111b554 swift::TypeChecker::typeCheckDecl(swift::Decl*, bool) + 116
11 swift-frontend           0x00000001011c83dc swift::TypeCheckSourceFileRequest::evaluate(swift::Evaluator&, swift::SourceFile*) const + 176
12 swift-frontend           0x00000001011ca0c0 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultUncached<swift::TypeCheckSourceFileRequest>(swift::TypeCheckSourceFileRequest const&) + 384
13 swift-frontend           0x00000001011c9e8c llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultCached<swift::TypeCheckSourceFileRequest, (void*)0>(swift::TypeCheckSourceFileRequest const&) + 108
14 swift-frontend           0x00000001011c823c swift::TypeCheckSourceFileRequest::OutputType swift::evaluateOrDefault<swift::TypeCheckSourceFileRequest>(swift::Evaluator&, swift::TypeCheckSourceFileRequest, swift::TypeCheckSourceFileRequest::OutputType) + 28
15 swift-frontend           0x000000010051b278 bool llvm::function_ref<bool (swift::SourceFile&)>::callback_fn<swift::CompilerInstance::performSema()::$_6>(long, swift::SourceFile&) + 16
16 swift-frontend           0x000000010051545c swift::CompilerInstance::forEachFileToTypeCheck(llvm::function_ref<bool (swift::SourceFile&)>) + 160
17 swift-frontend           0x0000000100515390 swift::CompilerInstance::performSema() + 76
18 swift-frontend           0x00000001004c6704 withSemanticAnalysis(swift::CompilerInstance&, swift::FrontendObserver*, llvm::function_ref<bool (swift::CompilerInstance&)>) + 56
19 swift-frontend           0x00000001004bd2d4 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
20 swift-frontend           0x00000001003f7108 swift::mainEntry(int, char const**) + 484
21 dyld                     0x0000000116f2d0f4 start + 520
zsh: abort      ../../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift file.swif
*/
