// This is not related to differentiable collections, but I'm putting it here for convenience.
// It happened even when I passed in -Xfrontend -requirement-machine-protocol-signatures=on -Xfrontend -requirement-machine-inferred-signatures=on -Xfrontend -requirement-machine-abstract-signatures=on

import Darwin
import Foundation
import Differentiation

@derivative(of: remainder(_:_:))
func _jvpRemainder<T: FloatingPoint & Differentiable>(_ x: Float, _ y: Float) -> (
  value: Float, pullback: (Float) -> (Float, Float)
) where T == T.TangentVector {
  return (remainder(x, y), { v in (v, -v * ((x / y).rounded(.toNearestOrEven))) })
}

print(gradient(at: Float(3), Float(0.9999), of: fmod))

/*
/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:18:20: error: generic parameter 'T' is not used in function signature
func _jvpRemainder<T: FloatingPoint & Differentiable>(_ x: Float, _ y: Float) -> (
                   ^
Assertion failed: (isa<X>(Val) && "cast<Ty>() argument of incompatible type!"), function cast, file Casting.h, line 269.
Please submit a bug report (https://swift.org/contributing/#reporting-bugs) and include the project and the crash backtrace.
Stack dump:
0.	Program arguments: /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2022-01-09-a.xctoolchain/usr/bin/swift-frontend -frontend -emit-module -experimental-skip-non-inlinable-function-bodies-without-types /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift -target arm64-apple-macos12.1 -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.1.sdk -I /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Products/Debug -F /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Products/Debug/PackageFrameworks -F /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Products/Debug/PackageFrameworks -F /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Products/Debug -enable-testing -g -module-cache-path /Users/philipturner/Library/Developer/Xcode/DerivedData/ModuleCache.noindex -swift-version 5 -enforce-exclusivity=checked -Onone -D DEBUG -new-driver-path /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2022-01-09-a.xctoolchain/usr/bin/swift-driver -serialize-debugging-options -resource-dir /Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2022-01-09-a.xctoolchain/usr/lib/swift -enable-anonymous-context-mangled-names -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Experimentation4-generated-files.hmap -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Experimentation4-own-target-headers.hmap -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Experimentation4-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/all-product-headers.yaml -Xcc -iquote -Xcc /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Experimentation4-project-headers.hmap -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Products/Debug/include -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/DerivedSources-normal/arm64 -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/DerivedSources/arm64 -Xcc -I/Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/DerivedSources -Xcc -DDEBUG=1 -Xcc -working-directory/Users/philipturner/Desktop/Experimentation4 -module-name Experimentation4 -target-sdk-version 12.1 -emit-module-doc-path /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Objects-normal/arm64/Experimentation4.swiftdoc -emit-module-source-info-path /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Objects-normal/arm64/Experimentation4.swiftsourceinfo -emit-objc-header-path /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Objects-normal/arm64/Experimentation4-Swift.h -o /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Objects-normal/arm64/Experimentation4.swiftmodule -emit-abi-descriptor-path /Users/philipturner/Library/Developer/Xcode/DerivedData/Experimentation4-fiujtigzqtbezegvwlbrrufbvmwx/Build/Intermediates.noindex/Experimentation4.build/Debug/Experimentation4.build/Objects-normal/arm64/Experimentation4.abi.json
1.	Apple Swift version 5.6-dev (LLVM 7b20e61dd04138a, Swift 9438cf6b2e83c5f)
2.	Compiling with the current language version
3.	While evaluating request TypeCheckSourceFileRequest(source_file "/Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift")
4.	While type-checking '_jvpRemainder(_:_:)' (at /Users/philipturner/Desktop/Experimentation4/Experimentation4/main.swift:18:1)
Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
0  swift-frontend           0x0000000108b065c0 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 56
1  swift-frontend           0x0000000108b05820 llvm::sys::RunSignalHandlers() + 128
2  swift-frontend           0x0000000108b06c24 SignalHandler(int) + 304
3  libsystem_platform.dylib 0x00000001bb5304e4 _sigtramp + 56
4  libsystem_pthread.dylib  0x00000001bb518eb0 pthread_kill + 288
5  libsystem_c.dylib        0x00000001bb456314 abort + 164
6  libsystem_c.dylib        0x00000001bb45572c err + 0
7  swift-frontend           0x0000000108e3e1dc swift::ASTVisitor<(anonymous namespace)::AttributeChecker, void, void, void, void, void, void>::visit(swift::DeclAttribute*) (.cold.276) + 0
8  swift-frontend           0x000000010533e4d8 swift::ASTVisitor<(anonymous namespace)::AttributeChecker, void, void, void, void, void, void>::visit(swift::DeclAttribute*) + 36096
9  swift-frontend           0x0000000105335184 swift::TypeChecker::checkDeclAttributes(swift::Decl*) + 200
10 swift-frontend           0x00000001053b0a30 (anonymous namespace)::DeclChecker::visitFuncDecl(swift::FuncDecl*) + 148
11 swift-frontend           0x00000001053a8d6c (anonymous namespace)::DeclChecker::visit(swift::Decl*) + 224
12 swift-frontend           0x00000001053a8c78 swift::TypeChecker::typeCheckDecl(swift::Decl*, bool) + 116
13 swift-frontend           0x0000000105451698 swift::TypeCheckSourceFileRequest::evaluate(swift::Evaluator&, swift::SourceFile*) const + 176
14 swift-frontend           0x0000000105453454 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultUncached<swift::TypeCheckSourceFileRequest>(swift::TypeCheckSourceFileRequest const&) + 400
15 swift-frontend           0x00000001054531f4 llvm::Expected<swift::TypeCheckSourceFileRequest::OutputType> swift::Evaluator::getResultCached<swift::TypeCheckSourceFileRequest, (void*)0>(swift::TypeCheckSourceFileRequest const&) + 124
16 swift-frontend           0x00000001054514dc swift::TypeCheckSourceFileRequest::OutputType swift::evaluateOrDefault<swift::TypeCheckSourceFileRequest>(swift::Evaluator&, swift::TypeCheckSourceFileRequest, swift::TypeCheckSourceFileRequest::OutputType) + 44
17 swift-frontend           0x00000001047f9f8c bool llvm::function_ref<bool (swift::SourceFile&)>::callback_fn<swift::CompilerInstance::performSema()::$_6>(long, swift::SourceFile&) + 16
18 swift-frontend           0x00000001047f68cc swift::CompilerInstance::forEachFileToTypeCheck(llvm::function_ref<bool (swift::SourceFile&)>) + 160
19 swift-frontend           0x00000001047f6800 swift::CompilerInstance::performSema() + 76
20 swift-frontend           0x00000001047a8fa8 withSemanticAnalysis(swift::CompilerInstance&, swift::FrontendObserver*, llvm::function_ref<bool (swift::CompilerInstance&)>) + 56
21 swift-frontend           0x000000010479fd08 swift::performFrontend(llvm::ArrayRef<char const*>, char const*, void*, swift::FrontendObserver*) + 2936
22 swift-frontend           0x000000010473e13c swift::mainEntry(int, char const**) + 500
23 dyld                     0x00000001111510f4 start + 520
*/
