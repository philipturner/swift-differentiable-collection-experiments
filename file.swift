//
//  main.swift
//  Experimentation4
//
//  Created by Philip Turner on 1/27/22.
//

import _Differentiation

// MARK: - Declare DiffRRCollection

public protocol DifferentiableCollection: MutableCollection & Differentiable & Equatable
where
  Element: Differentiable & AdditiveArithmetic,
  TangentVector: DifferentiableCollection, // this should be ElementTangentCollection.DifferentiableView if possible. Currently can't try `== DifferentiableCollectionView<ElementTangentCollection>` because of a compiler crash
  Element.TangentVector == TangentVector.Element,
  Index == TangentVector.Index
{
  associatedtype ElementTangentCollection: DifferentiableCollection
  where ElementTangentCollection.Element == Element.TangentVector
  
  // TODO: document that `zero` should be the empty collection
  static var zero: Self { get }
}

extension DifferentiableCollection {
  public typealias DifferentiableView = DifferentiableCollectionView<Self>
}

// MARK: - Declare DifferentiableView

/// The view of an array as the differentiable product manifold of `Element`
/// multiplied with itself `count` times.
@frozen
public struct DifferentiableCollectionView<Base: DifferentiableCollection> {
  public typealias ElementTangentCollection = Base.ElementTangentCollection
  
  var _base: Base
}

extension DifferentiableCollectionView: DifferentiableCollection {
  public typealias Element = Base.Element
  public typealias Index = Base.Index
  
  public subscript(position: Index) -> Element {
    _read {
      if position < endIndex {
        yield base[position]
      } else {
        yield Element.zero // why is this even allowed (and checked in tests)? If it is, shouldn't it check for position < base.startIndex too?
      }
    }
    set(newValue) {
      // if the above invalid subscript access is to be permitted, shouldn't some bounds checking happen here as well?
      base[position] = newValue
    }
  }
  
  public func index(after i: Index) -> Index {
    base.index(after: i)
  }
  
  public var startIndex: Index { base.startIndex }
  public var endIndex: Index { base.endIndex }
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
  public init(_ base: Base) { self._base = base } // can we remove `self`?
  
  @usableFromInline // why can't this be @inlinable (and other instances of @usableFromInline in the _Differentiation module)?
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
  
  public typealias TangentVector = Base.TangentVector
  
  public mutating func move(by offset: TangentVector) {
    if offset.isEmpty {
      return
    }
    precondition(
      base.count == offset.count, """
        Count mismatch: \(base.count) ('self') and \(offset.count) ('direction')
        """)
    
    for i in offset.indices {
      base[i].move(by: offset[i])
    }
  }
}

extension DifferentiableCollectionView: Equatable
where Element: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.base == rhs.base
  }
}

extension DifferentiableCollectionView: ExpressibleByArrayLiteral
where Base: RangeReplaceableCollection { // should I add the ExpresibleByArrayLiteral requirement to Base as well?
  public init(arrayLiteral elements: Element...) {
    self.init(Base(elements))
  }
}

// is it possible to implement ExpressibleByDictionaryLiteral? I tried and got nowhere. If it's not possible, make a TODO for if a future language future enables it.

// why is there only conformance for CustomStringConvertible and not CustomDebugStringConvertible or CustomReflectable?

extension DifferentiableCollectionView: CustomStringConvertible
where Base: CustomStringConvertible {
  public var description: String {
    return base.description
  }
}

/// Makes `Array.DifferentiableView` additive as the product space.
///
/// Note that `Array.DifferentiableView([])` is the zero in the product spaces
/// of all counts.
extension DifferentiableCollectionView: AdditiveArithmetic
where Element: AdditiveArithmetic {
  public static var zero: Self {
    return Self(Base.zero) // do I have to put this on a new line? If not, why is DifferentiableView.init a one-liner?
  }
  
  public static func + (lhs: Self, rhs: Self) -> Self {
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
  
  public static func - (lhs: Self, rhs: Self) -> Self {
    if lhs.base.count == 0 {
      return rhs
    }
    if rhs.base.count == 0 {
      return lhs
    }
    precondition(
      lhs.base.count == rhs.base.count,
      "Count mismatch: \(lhs.base.count) and \(rhs.base.count)")
    var difference = lhs
    for i in lhs.base.indices {
      difference[i] -= rhs[i]
    }
    return difference
  }
}

extension DifferentiableCollectionView: RangeReplaceableCollection
where Base: RangeReplaceableCollection, Base.SubSequence == Slice<Base> {
  // DO NOT explicitly declare `typealias SubSequence` or else the compiler will
  // crash.
  //typealias SubSequence == Slice<Base>
  
  public init() {
    self.init(Base.zero)
  }
  
  // Why is this argument label `bounds` in the standard library? Shouldn't it
  // be `position`? Inconsistencies like this may cause problems if overloading
  // subscripting operators for AutoDiff eventually requires specification
  // of argument labels.
  public subscript(bounds: Index) -> Element {
    get { base[bounds] }
  }
  
  public subscript(bounds: Range<Index>) -> Slice<Base> {
    get { base[bounds] }
  }
  
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Base.Index>,
    with newElements: C
  ) where C : Collection, Base.Element == C.Element {
    base.replaceSubrange(subrange, with: newElements)
  }
}

extension DifferentiableCollectionView: BidirectionalCollection
where Base: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    base.index(before: i)
  }
}

// MARK: - Extensions to DifferentiableCollection

/// Makes `Array` differentiable as the product manifold of `Element`
/// multiplied with itself `count` times.
extension DifferentiableCollection {
  // In an ideal world, `TangentVector` would be `[Element.TangentVector]`.
  // Unfortunately, we cannot conform `Array` to `AdditiveArithmetic` for
  // `TangentVector` because `Array` already has a static `+` method with
  // different semantics from `AdditiveArithmetic.+`. So we use
  // `Array.DifferentiableView` for all these associated types.
  //typealias TangentVector = ElementTangentCollection.DifferentiableView
  
  // TODO: - the `TangentVector` typealias is declared when conforming each individual collection protocol TO Differentiable. The typealias should NOT be declared here because of the compiler crash (it was in the original file). Where should the above documentation go then, if it still can't be declared here after the crash is fixed??
  
  public mutating func move(by offset: TangentVector) {
    var view = DifferentiableView(self)
    view.move(by: offset)
    self = view.base
  }
}

//===----------------------------------------------------------------------===//
// Derivatives
//===----------------------------------------------------------------------===//

extension DifferentiableCollection
where
  ElementTangentCollection: RangeReplaceableCollection,
  // not technically required by Swift, but we should add `Self: RangeReplaceableCollection` because `ElementTangentCollection` is supposed to be the same generic type just with a different Element
  ElementTangentCollection.Index == Index
{
  /// Must be overridden - I don't know how to best document this
  @_disfavoredOverload
  public subscript(position: Index) -> Element {
    get {
      fatalError("""
        \(Self.self) must override the default implementation of \
        `subscript(position:)` when conforming to `DifferentiableCollection`.
        """)
    }
    _modify {
      fatalError("""
        "\(Self.self) must override the default implementation of \
        `subscript(position:)` when conforming to `DifferentiableCollection`.
        """)
    }
  }
  
  @usableFromInline
  @derivative(of: subscript)
  func _vjpSubscript(index: Index) -> (
    value: Element, pullback: (Element.TangentVector) -> TangentVector
  ) {
    func pullback(_ v: Element.TangentVector) -> TangentVector {
      var dSelf = ElementTangentCollection(
        repeating: .zero,
        count: count
      )
      dSelf[index] = v
      return ElementTangentCollection.DifferentiableView(dSelf)
        as! Self.TangentVector
    }
    return (self[index], pullback)
  }
  
  @usableFromInline
  @derivative(of: subscript)
  func _jvpSubscript(index: Index) -> (
    value: Element, differential: (TangentVector) -> Element.TangentVector
  ) {
    func differential(_ v: TangentVector) -> Element.TangentVector {
      return v[index]
    }
    return (self[index], differential)
  }
}

extension DifferentiableCollection
where
  Self: RangeReplaceableCollection,
  ElementTangentCollection: RangeReplaceableCollection,
  ElementTangentCollection.SubSequence == Slice<ElementTangentCollection>,
  Index == Int // is there any way to remove this restriction?
{
  // We shouldn't need to duplicate this code for the generic signature
  // permutation `(lhs: Other, rhs: Self)` because `lhs` also conforms to
  // DifferentiableCollection and thus the signature would be `(lhs: Self,
  // rhs: Other)` relative to it. Although, this may diverge from the behavior
  // of the actual operator + in RangeReplaceableCollection, which would return
  // `Self` in either situation. Regardless, it's best to hold off on
  // duplicating the code until we're either confident this is the final
  // implementation or can set it up using gyb.
  
  // Alternatively, it would be possible to overload the alternative generic
  // signature by calling the existing function with swapped parameters. But,
  // that might make it complicated to conform to the protocol or open
  // opportunities to misuse it (i.e. just overload one of the two or make them
  // have different behavior). Maybe it's okay since that is technically
  // already possible with RangeReplaceableCollection.
  
  /// Must be overridden - I don't know how to best document this
  @_disfavoredOverload
  public static func + <Other: DifferentiableCollection>(
    lhs: Self,
    rhs: Other
  ) -> Self
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection,
    Other.TangentVector: RangeReplaceableCollection
  {
    fatalError("""
      \(Self.self) must override the default implementation of `+ (lhs:rhs:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @usableFromInline
  @derivative(of: +)
  static func _vjpConcatenate<Other: DifferentiableCollection>(
    _ lhs: Self,
    _ rhs: Other
  ) -> (
    value: Self,
    pullback: (TangentVector) -> (TangentVector, Other.TangentVector)
  )
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection,
    Other.TangentVector: RangeReplaceableCollection
  {
    func pullback(_ v: TangentVector) -> (TangentVector, Other.TangentVector) {
      if v.isEmpty {
        return (.zero, .zero)
      }
      precondition(
        v.count == lhs.count + rhs.count, """
          Tangent vector with invalid count \(v.count); expected to equal the \
          sum of operand counts \(lhs.count) and \(rhs.count)
          """)
      return (
        ElementTangentCollection.DifferentiableView(.init(v[..<lhs.count])),
        ElementTangentCollection.DifferentiableView(.init(v[lhs.count...]))
      ) as! (TangentVector, Other.TangentVector)
    }
    return (lhs + rhs, pullback)
  }
  
  @usableFromInline
  @derivative(of: +)
  static func _jvpConcatenate<Other: DifferentiableCollection>(
    _ lhs: Self,
    _ rhs: Other
  ) -> (
    value: Self,
    differential: (TangentVector, Other.TangentVector) -> TangentVector
  )
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection,
    Other.TangentVector: RangeReplaceableCollection
  {
    func differential(
      _ l: TangentVector,
      _ r: Other.TangentVector
    ) -> TangentVector {
      precondition(
        l.count == lhs.count && r.count == rhs.count, """
          Tangent vectors with invalid count; expected to equal the operand \
          counts \(lhs.count) and \(rhs.count)
          """)
      return ElementTangentCollection.DifferentiableView(l + r)
        as! Self.TangentVector
    }
    return (lhs + rhs, differential)
  }
}

extension DifferentiableCollection
where
  Self: RangeReplaceableCollection & BidirectionalCollection,
  TangentVector: RangeReplaceableCollection & BidirectionalCollection,
  ElementTangentCollection: RangeReplaceableCollection &
    BidirectionalCollection, // should I keep this on the line above for readability?
  ElementTangentCollection.SubSequence == Slice<ElementTangentCollection>,
  Index == Int
{
  @_disfavoredOverload
  public mutating func append(_ newElement: Element) {
    fatalError("""
      \(Self.self) must override the default implementation of `append(_:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  // isn't there any rule for which order we declare JVP and VJP in? For tgmath,
  // it was JVP then VJP. Here, it's the reverse.
  @usableFromInline
  @derivative(of: append(_:))
  mutating func _vjpAppend(_ element: Element) -> (
    value: Void, pullback: (inout TangentVector) -> Element.TangentVector
  ) {
    let appendedElementIndex = count
    append(element)
    return ((), { v in
      // can't be just use popLast() to remove the restriction that Index == Int?
      defer { v.removeLast() }
      return v[appendedElementIndex]
    })
  }
  
  @usableFromInline
  @derivative(of: append(_:))
  mutating func _jvpAppend(_ element: Element) -> (
    value: Void,
    differential: (inout TangentVector, Element.TangentVector) -> Void
  ) {
    append(element)
    return ((), { $0.append($1) })
  }
  
  // TODO: check that this actually translates into a change in
  // behavior of `append(contentsOf:)`. Otherwise, there might need to be
  // a LOT more overloading of behavior of sequences' methods - enough
  // to make it impossible to conform custom collections to Differentiable
  // unless they just conform select methods
  
  @_disfavoredOverload
  public static func += <Other: DifferentiableCollection>(
    _ lhs: inout Self,
    rhs: Other
  )
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection & BidirectionalCollection,
    Other.TangentVector: RangeReplaceableCollection & BidirectionalCollection,
    Other.ElementTangentCollection: RangeReplaceableCollection &
      BidirectionalCollection
  {
    fatalError("""
      \(Self.self) must override the default implementation of `append(_:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @usableFromInline
  @derivative(of: +=)
  static func _vjpAppend<Other: DifferentiableCollection>(
    _ lhs: inout Self,
    _ rhs: Other
  ) -> (
    value: Void, pullback: (inout TangentVector) -> Other.TangentVector
  )
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection & BidirectionalCollection,
    Other.TangentVector: RangeReplaceableCollection & BidirectionalCollection,
    Other.ElementTangentCollection: RangeReplaceableCollection &
      BidirectionalCollection
  {
    let lhsCount = lhs.count
    lhs += rhs
    return ((), { v in
      let drhs = Other.ElementTangentCollection.DifferentiableView(
        .init(v.dropFirst(lhsCount))) as! Other.TangentVector
      let rhsCount = drhs.count
      v.removeLast(rhsCount)
      return drhs
    })
  }
  
  @usableFromInline
  @derivative(of: +=)
  static func _jvpAppend<Other: DifferentiableCollection>(
    _ lhs: inout Self,
    _ rhs: Other
  ) -> (
    value: Void, differential: (inout TangentVector, Other.TangentVector) -> Void
  )
  where
    Element == Other.Element,
    Other: RangeReplaceableCollection & BidirectionalCollection,
    Other.TangentVector: RangeReplaceableCollection & BidirectionalCollection,
    Other.ElementTangentCollection: RangeReplaceableCollection &
      BidirectionalCollection
  {
    lhs += rhs
    return ((), { $0 += $1 })
  }
}

// Might have to comment this out for the time being because of the compiler
// crash. Thus, we can't merge it because it would remove functionality from
// Array (a workaround is to copy and paste the old code for Array).
extension DifferentiableCollection
where
  Self: RangeReplaceableCollection,
  ElementTangentCollection: RangeReplaceableCollection,
  ElementTangentCollection.SubSequence == Slice<ElementTangentCollection>
{
  @_disfavoredOverload
  public init(repeating: Element, count: Int) {
    fatalError("""
      \(Self.self) must override the default implementation of \
      `init(repeating:count)` when conforming to `DifferentiableCollection`.
      """)
  }
  
  @usableFromInline
  @derivative(of: init(repeating:count:))
  static func _vjpInit(repeating repeatedValue: Element, count: Int) -> (
    value: Self, pullback: (TangentVector) -> Element.TangentVector
  ) {
    return (
      value: Self(repeating: repeatedValue, count: count),
      pullback: { v in
        v.reduce(.zero, +)
      }
    )
  }
  
  @usableFromInline
  @derivative(of: init(repeating:count:))
  static func _jvpInit(repeating repeatedValue: Element, count: Int) -> (
    value: Self, differential: (Element.TangentVector) -> TangentVector
  ) {
    (
      value: Self(repeating: repeatedValue, count: count),
      differential: { v in
        ElementTangentCollection.DifferentiableView(repeating: v, count: count)
          as! TangentVector
      }
    )
  }
}

//===----------------------------------------------------------------------===//
// Differentiable higher order functions for collections
//===----------------------------------------------------------------------===//

// we need to extend differentiability to as many stdlib collection protocols
// and protocol methods as possible. For now, this hasn't happened yet just so
// that the existing prototype can be validated and discussed.

#if false // the alternative extension that causes the crash
extension DifferentiableCollection {
  @inlinable
  @differentiable(reverse, wrt: self)
  public func differentiableMap<Result: Differentiable>(
    _ body: @differentiable(reverse) (Element) -> Result
  ) -> [Result] {
    map(body)
  }
}
#endif

#if true
extension DifferentiableCollection
where
  Self: RangeReplaceableCollection,
  ElementTangentCollection: RangeReplaceableCollection,
  ElementTangentCollection.SubSequence == Slice<ElementTangentCollection>,
  Index == Int
{
  @inlinable
//  @differentiable(reverse, wrt: self) // --- test enabling this to see if it
  // crashes the compiler. If so, isolate and report.
  public func differentiableMap<Result: DifferentiableCollection>(
    _ body: @differentiable(reverse) (Element) -> Result.Element
  ) -> Result
  where
    Result: RangeReplaceableCollection,
    Result.TangentVector: RangeReplaceableCollection,
    Result.ElementTangentCollection: RangeReplaceableCollection,
    Result.Index == Int
  {
    // try to overload with something more optimized in the case of Array
    //map(body)
    var output = Result()
    for element in self {
      output.append(body(element))
    }
    return output
  }
  
  // why is the _vjp explicitly internal?
  @inlinable
  @derivative(of: differentiableMap)
  internal func _vjpDifferentiableMap<Result: DifferentiableCollection>(
    _ body: @differentiable(reverse) (Element) -> Result.Element
  ) -> (
    value: Result,
    pullback: (Result.TangentVector) -> TangentVector
  )
  where
    Result: RangeReplaceableCollection,
    Result.TangentVector: RangeReplaceableCollection,
    Result.ElementTangentCollection: RangeReplaceableCollection,
    Result.Index == Int
  {
    var values = Result()
    var pullbacks: [(Result.Element.TangentVector) -> Element.TangentVector] = []
    for x in self {
      let (y, pb) = valueWithPullback(at: x, of: body)
      values.append(y)
      pullbacks.append(pb)
    }
    func pullback(_ tans: Result.TangentVector) -> TangentVector {
      // try to overload with something more optimized in the case of Array
      //map(body)
      var output = ElementTangentCollection()
      for i in tans.indices {
        output.append(pullbacks[i](tans[i]))
      }
      return ElementTangentCollection.DifferentiableView(output)
       as! TangentVector
    }
    return (value: values, pullback: pullback)
  }

  // why is the _jvp explicitly internal?
}
#endif

// TODO: - second part, ask why only _jvp is not `internal`


