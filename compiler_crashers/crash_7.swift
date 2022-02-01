// This is not related to differentiable collections, but I'm putting it here for convenience.
// This happens regardless of whether RequirementMachine is on.
// The stack trace is very similar to crash_4.swift.

import _Differentiation

struct Q { }

@derivative(of: remainder(_:_:))
func _vjpRemainder<T: FloatingPoint>(_ x: Q, _ y: Q) -> (
  value: Q, pullback: (Q) -> (Q, Q)
) {
  fatalError()
}

/*
file.swift:6:20: error: generic parameter 'T' is not used in function signature
func _vjpRemainder<T: FloatingPoint>(_ x: Q, _ y: Q) -> (
                   ^
Assertion failed: (isa<X>(Val) && "cast<Ty>() argument of incompatible type!"), function cast, file Casting.h, line 269.
Stack dump:
0.	Program arguments: /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-frontend -frontend -interpret file.swift -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -color-diagnostics -new-driver-path /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift-driver -requirement-machine-protocol-signatures=on -requirement-machine-inferred-signatures=on -requirement-machine-abstract-signatures=on -enable-experimental-forward-mode-differentiation -enable-cross-import-overlays -resource-dir /Users/philipturner/Documents/Swift-Compiler/swift-project/build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/lib/swift -module-name file -target-sdk-version 12.1
1.	Swift version 5.7-dev (LLVM 59972a8d54ac3bf, Swift cb83622f142351b)
2.	Compiling with the current language version
3.	While evaluating request TypeCheckSourceFileRequest(source_file "file.swift")
4.	While type-checking '_vjpRemainder(_:_:)' (at file.swift:6:1)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000104e7c104 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000104e7b234 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000104e7c768 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  libsystem_c.dylib        0x00000001bb45572c err + 0
7  swift-frontend           0x00000001052c9644 swift::ASTVisitor<(anonymous namespace)::AttributeChecker, void, void, void, void, void, void>::visit(swift::DeclAttribute*) (.cold.278) + 0
8  swift-frontend           0x000000010117f34c swift::ASTVisitor<(anonymous namespace)::AttributeChecker, void, void, void, void, void, void>::visit(swift::DeclAttribute*) + 36136
9  swift-frontend           0x0000000101175fec swift::TypeChecker::checkDeclAttributes(swift::Decl*) + 184
10 swift-frontend           0x0000000101200d20 (anonymous namespace)::DeclChecker::visitFuncDecl(swift::FuncDecl*) + 148
11 swift-frontend           0x00000001011f90e0 (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
12 swift-frontend           0x00000001011f8fec swift::TypeChecker::typeCheckDecl(swift::Decl*, bool) + 116
13 swift-frontend           0x00000001012a5e84 swift::TypeCheckSourceFileRequest::evaluate(swift::Evaluator&, swift::SourceFile*) const + 176
14 swift-frontend           0x00000001012a7b68 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultUncached<swift::TypeCheckSourceFileRequest>(swift::TypeCheckSourceFileRequest const&) + 384
15 swift-frontend           0x00000001012a7934 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultCached<swift::TypeCheckSourceFileRequest, (void*)0>(swift::TypeCheckSourceFileRequest const&) + 108
16 swift-frontend           0x00000001012a5ce4 swift::TypeCheckSourceFileRequest::OutputType swift::evaluateOrDefault<swift::TypeCheckSourceFileRequest>(swift::Evaluator&, swift::TypeCheckSourceFileRequest, swift::TypeCheckSourceFileRequest::OutputType) + 28
17 swift-frontend           0x00000001005ef5f8 bool llvm::function_ref<bool (swift::SourceFile&)>::callback_fn<swift::CompilerInstance::performSema()::$_6>(long, swift::SourceFile&) + 16
18 swift-frontend           0x00000001005e97dc swift::CompilerInstance::forEachFileToTypeCheck(llvm::function_ref<bool (swift::SourceFile&)>) + 160
19 swift-frontend           0x00000001005e9710 swift::CompilerInstance::performSema() + 76
20 swift-frontend           0x000000010059a0f8 withSemanticAnalysis(swift::CompilerInstance&, swift::FrontendObserver*, llvm::function_ref<bool (swift::CompilerInstance&)>) + 56
21 swift-frontend           0x0000000100590cb4 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 3012
22 swift-frontend           0x00000001004caab8 swift::mainEntry(int, char const**) + 484
23 dyld                     0x00000001172750f4 start + 520
zsh: abort      ../build/Ninja-RelWithDebInfoAssert/swift-macosx-arm64/bin/swift -Xfrontend  
*/
