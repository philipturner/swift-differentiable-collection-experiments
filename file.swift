//
//  main.swift
//  Experimentation4
//
//  Created by Philip Turner on 1/27/22.
//

import _Differentiation

// MARK: - Declare DiffRRCollection

protocol DifferentiableCollection: MutableCollection & Differentiable & Equatable
where Element: Differentiable & AdditiveArithmetic,
      TangentVector: DifferentiableCollection, // this should be ElementTangentCollection.DifferentiableView. Currently can't try `== DifferentiableCollectionView<ElementTangentCollection>` because of a compiler crash
      Element.TangentVector == TangentVector.Element,
      Index == TangentVector.Index
{
  associatedtype ElementTangentCollection: DifferentiableCollection
  where ElementTangentCollection.Element == Element.TangentVector
  
  static var zero: Self { get }
}

extension DifferentiableCollection {
  typealias DifferentiableView = DifferentiableCollectionView<Self>
}

// MARK: - Declare DifferentiableView

/// The view of an array as the differentiable product manifold of `Element`
/// multiplied with itself `count` times.
// @frozen - TODO: try this
struct DifferentiableCollectionView<Base: DifferentiableCollection> {
  typealias ElementTangentCollection = Base.ElementTangentCollection
  
  var _base: Base
}

extension DifferentiableCollectionView: DifferentiableCollection {
  typealias Element = Base.Element
  typealias Index = Base.Index
  
  subscript(position: Index) -> Element {
    _read {
      if position < endIndex {
        yield base[position]
      } else {
        yield Element.zero // why is this even allowed? And shouldn't it check for position < base.startIndex too?
      }
    }
    set(newValue) {
      // if the above invalid subscript access is to be permitted, shouldn't some bounds checking happen here as well?
      base[position] = newValue
    }
  }
  
  func index(after i: Index) -> Index {
    base.index(after: i)
  }
  
  var startIndex: Index { base.startIndex }
  var endIndex: Index { base.endIndex }
}

// MARK: - Declare conformances

extension DifferentiableCollectionView: Differentiable {
  /// The viewed array.
  public var base: Base {
    get { _base }
    _modify { yield &_base }
  }
  
  @usableFromInline
  @derivative(of: base)
  func _vjpBase() -> (
    value: Base, pullback: (Base.TangentVector) -> TangentVector // is `Base.` really necessary? if so, shouldn't it be `(TangentVector) -> Base.TangentVector`?
  ) {
    return (base, { $0 })
  }
  
  @usableFromInline
  @derivative(of: base)
  func _jvpBase() -> (
    value: Base, differential: (Base.TangentVector) -> TangentVector // is `Base.` really necessary?
  ) {
    return (base, { $0 })
  }
  
  /// Creates a differentiable view of the given array.
  init(_ base: Base) { self._base = base } // can we remove `self`?
  
  @usableFromInline
  @derivative(of: init(_:))
  static func _vjpInit(_ base: Base) -> (
    value: Self, pullback: (TangentVector) -> TangentVector
  ) {
    return (Self(base), { $0 })
  }
  
  @usableFromInline
  @derivative(of: init(_:))
  static func _jvpInit(_ base: Base) -> (
    value: Self, differential: (TangentVector) -> TangentVector
  ) {
    return (Self(base), { $0 })
  }
  
  typealias TangentVector = Base.TangentVector
  
  mutating func move(by offset: TangentVector) {
    if offset.isEmpty {
      return
    }
    precondition(
      base.count == offset.count, """
        Count mismatch: \(base.count) ('self') and \(offset.count) \
        ('direction')
        """)
    
    for i in offset.indices {
      base[i].move(by: offset[i])
    }
  }
}

extension DifferentiableCollectionView: Equatable
where Element: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.base == rhs.base
  }
}

extension DifferentiableCollectionView: AdditiveArithmetic
where Element: AdditiveArithmetic {
  static var zero: Self { Self(Base.zero) }
  
  static func + (lhs: Self, rhs: Self) -> Self {
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    precondition(
      lhs.base.count == rhs.base.count,
      "Count mismatch: \(lhs.base.count) and \(rhs.base.count)")
    var sum = lhs
    for i in lhs.base.indices {
      sum[i] += rhs[i]
    }
    return sum
  }
  
  static func - (lhs: Self, rhs: Self) -> Self {
    if lhs.count == 0 {
      return rhs
    }
    if rhs.count == 0 {
      return lhs
    }
    precondition(
      lhs.count == rhs.count,
      "Count mismatch: \(lhs.count) and \(rhs.count)")
    var difference = lhs
    for i in lhs.indices {
      difference[i] -= rhs[i]
    }
    return difference
  }
}

//extension Array: AdditiveArithmetic where Element: Equatable {
//  public static var zero: Self { fatalError() }//Self(Base) }
//
//  public static func - (lhs: Self, rhs: Self) -> Self {
//    fatalError()
//  }
//  @_disfavoredOverload
//  public static func + (lhs: Self, rhs: Self) -> Self {
//    fatalError()
//  }
//}

// give Array conformance to AdditiveArithmetic.+ in the standard library, but use `@_disfavoredOverload`
// TODO: - see if the above idea can be pulled off

// the following won't work.
//print((+ as (AdditiveArithmetic, AdditiveArithmetic) -> AdditiveArithmetic)([Int](), [Int]()))
//
// but, maybe if it's used inside of some generic code treating it as an AdditiveArithmetic

// if I can pull this off, maybe I can avoid the `DifferentiableView` stuff

//print([Int]() + [Int]())
//
//print("erewrewr")

//print(AdditiveArie([Int]() as AdditiveArithmetic) + ([Int]() as AdditiveArithmetic))

/*
 
 protocol DiffRRCollection: Collection & Differentiable
 where Index == Int,
       Element: Differentiable,
       TangentVector: DiffRRCollection, // this should be Array<T.Tangent>.DifferentiableView
       TangentVector.Element == Element.TangentVector {
   associatedtype SelfOfElementTan: DiffRRCollection
   where SelfOfElementTan.Element == Element.TangentVector
 }

 struct DifferentiableCollectionView<T: DiffRRCollection>: DiffRRCollection {
   func index(after i: Int) -> Int {
     fatalError()
   }
   
   subscript(position: Int) -> T.Element {
     _read {
       fatalError()
     }
   }
   
   var startIndex: Int { fatalError() }
   
   var endIndex: Int { fatalError() }
   
   typealias SelfOfElementTan = T.SelfOfElementTan
   
   init() {
     fatalError()
   }
   
   typealias Element = T.Element
   
   var _base: T
 }

 extension DiffRRCollection {
   typealias DifferentiableView = DifferentiableCollectionView<Self>
 }

 // MARK: - Declare conformances

 extension DifferentiableCollectionView: Differentiable {
   typealias TangentVector = T.TangentVector
   
   mutating func move(by offset: TangentVector) {}
 }

 extension DifferentiableCollectionView: Equatable
 where T.Element: Equatable {
   static func == (lhs: Self, rhs: Self) -> Bool {
     fatalError()
   }
 }

 extension DifferentiableCollectionView: AdditiveArithmetic
 where T.Element: AdditiveArithmetic {
   static var zero: Self { fatalError() }
   
   static func - (lhs: Self, rhs: Self) -> Self {
     fatalError()
   }
   
   static func + (lhs: Self, rhs: Self) -> Self {
     fatalError()
   }
 }

 
 
 */





/*
 
 
 //
 //  main.swift
 //  Experimentation4
 //
 //  Created by Philip Turner on 1/27/22.
 //

 import _Differentiation

 // MARK: - Declare types

 /*
  
  , // this should be Array<T.Tangent>.DifferentiableView
  TangentVector.Element == Element.TangentVector
  */

 // DiffRRCollection can't conform to AdditiveArithmetic
 protocol DiffRRCollection: RangeReplaceableCollection & Differentiable & AdditiveArithmetic
 where Element: Differentiable & AdditiveArithmetic,
   TangentVector == DifferentiableCollectionView<SelfOfElementTan>,
       TangentVector.Element == Element.TangentVector {
 //      TangentVector: DiffCollViewProtocol,
 //      TangentVector.T == SelfOfElementTan {
 //      SelfOfElementTan.Element == Element.TangentVector {
   associatedtype SelfOfElementTan: DiffRRCollection
 }

 //protocol DiffCollViewProtocol: AdditiveArithmetic {
 //  associatedtype T: DiffRRCollection & AdditiveArithmetic
 //}

 struct DifferentiableCollectionView<T: DiffRRCollection & AdditiveArithmetic>
 where T.Element: AdditiveArithmetic {
   typealias Element = T.Element
   var _base: T
 }

 extension DiffRRCollection {
   typealias DifferentiableView = DifferentiableCollectionView<Self>
 }

 // MARK: - Declare conformances

 // todo: maybe make a sub-type of DiffRRCollection where TangentVector equals a DifferentiableCollectionView?
 // or conform DifferentiableCollectionView to RangeReplaceableCollection?

 extension DifferentiableCollectionView: Differentiable {
   typealias TangentVector = T.TangentVector

   mutating func move(by offset: TangentVector) {}
 }

 extension DifferentiableCollectionView: Equatable
 where T.Element: Equatable {
   static func == (lhs: Self, rhs: Self) -> Bool {
     fatalError()
   }
 }

 extension DifferentiableCollectionView: AdditiveArithmetic
 where T.Element: AdditiveArithmetic {
   static var zero: Self { fatalError() }

   static func - (lhs: Self, rhs: Self) -> Self {
     fatalError()
   }

   static func + (lhs: Self, rhs: Self) -> Self {
     fatalError()
   }
 }

 
 
 */
