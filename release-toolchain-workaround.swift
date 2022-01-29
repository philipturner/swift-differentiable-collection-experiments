//
//  main.swift
//  Experimentation4
//
//  Created by Philip Turner on 1/27/22.
//

// By using Xcode 13.2.1 release toolchain + my Differentiation package, I can
// work around errors caused by RequirementMachine.
import Differentiation

// MARK: - Declare DifferentiableCollection

// NOTE: - instead of making @_disfavoredOverload operators, make sub-protocols
// of DifferentiableRangeReplaceableCollection - use the operators inherited
// there.

// Must be a `MutableCollection` to that each element can be modified in the
// `move` operator. Although in theory, one might be able to have a workaround
// where you construct a new copy and reassign `self`, that would go against the
// philosophy of `MutableCollection` and probably have O(n^2) performance.
public protocol DifferentiableCollection: MutableCollection, Differentiable
where
  Element: Differentiable & AdditiveArithmetic,
  TangentVector == ElementTangentCollection.DifferentiableView,
  TangentVector.Base == ElementTangentCollection
{
  associatedtype DifferentiableView: DifferentiableCollectionViewProtocol
  
  associatedtype ElementTangentCollection: DifferentiableCollection
  where
    ElementTangentCollection.Element == Element.TangentVector,
    ElementTangentCollection.Element == TangentVector.Element,
    ElementTangentCollection.Index == Index // is it possible to remove this restriction?
  
  static var zero: Self { get } // should this be renamed to `empty`?
  
  func elementsEqual(_ other: Self) -> Bool
}

/// Makes `Array` differentiable as the product manifold of `Element`
/// multiplied with itself `count` times.
extension DifferentiableCollection {
  // In an ideal world, `TangentVector` would be `[Element.TangentVector]`.
  // Unfortunately, we cannot conform `Array` to `AdditiveArithmetic` for
  // `TangentVector` because `Array` already has a static `+` method with
  // different semantics from `AdditiveArithmetic.+`. So we use
  // `Array.DifferentiableView` for all these associated types.
  public typealias DifferentiableView = DifferentiableCollectionView<Self>
  // TODO: - the above documentation isn't 100% appropriate because
  // declaration of `TangentVector` has been moved outside of this block of code
  
  public mutating func move(by offset: TangentVector) {
    var view = DifferentiableView(self)
    view.move(by: offset)
    self = view.base
  }
}

// MARK: - Declare conformances

public protocol DifferentiableCollectionViewProtocol: DifferentiableCollection {
  associatedtype Base: DifferentiableCollection
  
  var base: Base { get set }
  
  init(_ base: Base)
}

public struct DifferentiableCollectionView<Base: DifferentiableCollection>: DifferentiableCollectionViewProtocol {
  public typealias ElementTangentCollection = Base.ElementTangentCollection
  
  var _base: Base // why do we need a wrapper and extra code to access it? It's boilerplate code and prevents differentiation of _modify.
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
        //
        // Maybe it's to allow for an optimized .zero type like Tensor.zero?
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
  
  @inlinable // I changed a lot of instances of @usableFromInline to @inlinable. I'd rather not make a side note on every single example. Is there any reason not to do this?
  @derivative(of: base.get)
  func _vjpBase() -> (
    value: Base, pullback: (Base.TangentVector) -> TangentVector // is `Base.` really necessary? if so, shouldn't it be `(TangentVector) -> Base.TangentVector`?
  ) {
    return (base, { $0 })
  }
  
  // TODO: add derivative of base._modify once that's supported

  @inlinable
  @derivative(of: base.get)
  func _jvpBase() -> (
    value: Base, differential: (Base.TangentVector) -> TangentVector // is `Base.` really necessary?
  ) {
    return (base, { $0 })
  }
  
  // TODO: add derivative of base._modify once that's supported
  
  /// Creates a differentiable view of the given array.
  public init(_ base: Base) {
    _base = base
  }
  
  @inlinable
  @derivative(of: init(_:))
  static func _vjpInit(_ base: Base) -> (
    value: Self, pullback: (TangentVector) -> TangentVector
  ) {
    return (Self(base), { $0 })
  }

  @inlinable
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
    lhs.base.elementsEqual(rhs.base)
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

// MARK: - DifferentiableRangeReplaceableCollection

public protocol DifferentiableRangeReplaceableCollection:
  DifferentiableCollection, RangeReplaceableCollection
where
  TangentVector: RangeReplaceableCollection,
  ElementTangentCollection: RangeReplaceableCollection
{
  
}

extension DifferentiableCollectionView: RangeReplaceableCollection
where Base: RangeReplaceableCollection {
  public init() {
    self.init(Base.zero)
  }
  
  public subscript(position: Index) -> Element {
    get { base[position] }
  }
  
  public subscript(bounds: Range<Index>) -> Base.SubSequence {
    get { base[bounds] }
  }
  
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Base.Index>,
    with newElements: C
  ) where C : Collection, Base.Element == C.Element {
    base.replaceSubrange(subrange, with: newElements)
  }
}

// MARK: - DifferentiableBidirectionalCollection

public protocol DifferentiableBidirectionalCollection:
  DifferentiableCollection, BidirectionalCollection
where
  TangentVector: BidirectionalCollection,
  ElementTangentCollection: BidirectionalCollection
{
  
}

extension DifferentiableCollectionView: BidirectionalCollection
where Base: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    base.index(before: i)
  }
}

//===----------------------------------------------------------------------===//
// Derivatives
//===----------------------------------------------------------------------===//

extension DifferentiableRangeReplaceableCollection {
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
  
  @inlinable
  @derivative(of: subscript.get)
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
  
  // TODO: add derivative of subscript._modify once that's supported
  
  @inlinable
  @derivative(of: subscript.get)
  func _jvpSubscript(index: Index) -> (
    value: Element, differential: (TangentVector) -> Element.TangentVector
  ) {
    func differential(_ v: TangentVector) -> Element.TangentVector {
      return v[index]
    }
    return (self[index], differential)
  }
  
  // TODO: add derivative of subscript._modify once that's supported
}

extension DifferentiableRangeReplaceableCollection
where Index == Int // is there any way to remove this restriction?
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
  public static func + <Other: DifferentiableRangeReplaceableCollection>(
    lhs: Self,
    rhs: Other
  ) -> Self
  where
    Element == Other.Element
  {
    fatalError("""
      \(Self.self) must override the default implementation of `+ (lhs:rhs:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @inlinable
  @derivative(of: +)
  static func _vjpConcatenate<Other: DifferentiableRangeReplaceableCollection>(
    _ lhs: Self,
    _ rhs: Other
  ) -> (
    value: Self,
    pullback: (TangentVector) -> (TangentVector, Other.TangentVector)
  )
  where
    Element == Other.Element
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
        TangentVector(.init(v[..<lhs.count])),
        Other.TangentVector(.init(v[lhs.count...]))
      )
    }
    return (lhs + rhs, pullback)
  }
  
  @inlinable
  @derivative(of: +)
  static func _jvpConcatenate<Other: DifferentiableRangeReplaceableCollection>(
    _ lhs: Self,
    _ rhs: Other
  ) -> (
    value: Self,
    differential: (TangentVector, Other.TangentVector) -> TangentVector
  )
  where
    Element == Other.Element
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
      return TangentVector(l + r)
    }
    return (lhs + rhs, differential)
  }
}

extension DifferentiableRangeReplaceableCollection
where Self: DifferentiableBidirectionalCollection
{
  @_disfavoredOverload
  public mutating func append(_ newElement: Element) {
    fatalError("""
      \(Self.self) must override the default implementation of `append(_:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @inlinable
  @derivative(of: append(_:))
  mutating func _vjpAppend(_ element: Element) -> (
    value: Void, pullback: (inout TangentVector) -> Element.TangentVector
  ) {
    // I removed the call to extract `count` here.
    append(element)
    return ((), { v in
      v.popLast()! // implicitly unwrapping the optional is the only way to prevent the restriction that `Index == Int`. Plus, this is the same behavior as the previous implementation.
    })
  }
  
  @inlinable
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
  public static func += <Other: DifferentiableRangeReplaceableCollection>(
    _ lhs: inout Self,
    rhs: Other
  )
  where
    Element == Other.Element,
    Other: DifferentiableBidirectionalCollection
  {
    fatalError("""
      \(Self.self) must override the default implementation of `append(_:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @inlinable
  @derivative(of: +=)
  static func _vjpAppend<Other: DifferentiableRangeReplaceableCollection>(
    _ lhs: inout Self,
    _ rhs: Other
  ) -> (
    value: Void, pullback: (inout TangentVector) -> Other.TangentVector
  )
  where
    Element == Other.Element,
    Other: DifferentiableBidirectionalCollection
  {
    let lhsCount = lhs.count
    lhs += rhs
    return ((), { v -> Other.TangentVector in
      let drhs = Other.TangentVector(.init(v.dropFirst(lhsCount)))
      let rhsCount = drhs.count
      v.removeLast(rhsCount)
      return drhs
    })
  }
  
  @inlinable
  @derivative(of: +=)
  static func _jvpAppend<Other: DifferentiableRangeReplaceableCollection & DifferentiableBidirectionalCollection>(
    _ lhs: inout Self,
    _ rhs: Other
  ) -> (
    value: Void,
    differential: (inout TangentVector, Other.TangentVector) -> Void
  )
  where Element == Other.Element /* TODO: fix generic signature declaration to match */ {
    lhs += rhs
    return ((), { $0 += $1 })
  }
}

extension DifferentiableRangeReplaceableCollection {
  @_disfavoredOverload
  public init(repeating: Element, count: Int) {
    fatalError("""
      \(Self.self) must override the default implementation of \
      `init(repeating:count)` when conforming to `DifferentiableCollection`.
      """)
  }
  
  @inlinable
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
  
  @inlinable
  @derivative(of: init(repeating:count:))
  static func _jvpInit(repeating repeatedValue: Element, count: Int) -> (
    value: Self, differential: (Element.TangentVector) -> TangentVector
  ) {
    (
      value: Self(repeating: repeatedValue, count: count),
      differential: { v in
        TangentVector(repeating: v, count: count)
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

extension DifferentiableRangeReplaceableCollection {
  @inlinable
  @differentiable(reverse, wrt: self)
  public func differentiableMap<Result: Differentiable>(
    _ body: @differentiable(reverse) (Element) -> Result
  ) -> [Result] {
    map(body)
  }
  
  @inlinable
  @derivative(of: differentiableMap)
  func _vjpDifferentiableMap<Result: Differentiable>(
    _ body: @differentiable(reverse) (Element) -> Result
  ) -> (
    value: [Result],
    pullback: (Array<Result>.TangentVector) -> TangentVector
  ) {
    var values: [Result] = []
    values.reserveCapacity(count)
    var pullbacks: [(Result.TangentVector) -> Element.TangentVector] = []
    pullbacks.reserveCapacity(count)
    for x in self {
      let (y, pb) = valueWithPullback(at: x, of: body)
      values.append(y)
      pullbacks.append(pb)
    }
    func pullback(_ tans: Array<Result>.TangentVector) -> TangentVector {
      // TODO: Right now, it uses the old Array.DifferentiableView because it
      // relies on my Differentiation module. In the final form, we will remove
      // `.base` from `tans.base`.
      // TODO: conform Array to Differentiable and have it override the existing
      // implementation in the stdlib
      .init(zip(tans.base, pullbacks).map { tan, pb in pb(tan) })
    }
    return (value: values, pullback: pullback)
  }
  
  @inlinable
  @derivative(of: differentiableMap)
  func _jvpDifferentiableMap<Result: Differentiable>(
    _ body: @differentiable(reverse) (Element) -> Result
  ) -> (
    value: [Result],
    differential: (TangentVector) -> Array<Result>.TangentVector
  ) {
    var values: [Result] = []
    values.reserveCapacity(count)
    var differentials: [(Element.TangentVector) -> Result.TangentVector] = []
    values.reserveCapacity(count)
    for x in self {
      let (y, df) = valueWithDifferential(at: x, of: body)
      values.append(y)
      differentials.append(df)
    }
    func differential(_ tans: TangentVector) -> Array<Result>.TangentVector {
      .init(zip(tans, differentials).map { tan, df in df(tan) })
    }
    return (value: values, differential: differential)
  }
}

extension DifferentiableRangeReplaceableCollection
where Self: DifferentiableBidirectionalCollection {
  @inlinable
  @differentiable(reverse, wrt: (self, initialResult))
  public func differentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult:
      @differentiable(reverse) (Result, Element) -> Result
  ) -> Result {
    reduce(initialResult, nextPartialResult)
  }
  
  @inlinable
  @derivative(of: differentiableReduce)
  func _vjpDifferentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable(reverse) (Result, Element) -> Result
  ) -> (
    value: Result,
    pullback: (Result.TangentVector)
      -> (TangentVector, Result.TangentVector)
  ) {
    var pullbacks:
      [(Result.TangentVector) -> (Result.TangentVector, Element.TangentVector)] =
        []
    let count = self.count
    pullbacks.reserveCapacity(count)
    var result = initialResult
    for element in self {
      let (y, pb) =
        valueWithPullback(at: result, element, of: nextPartialResult)
      result = y
      pullbacks.append(pb)
    }
    return (
      value: result,
      pullback: { tangent in
        var resultTangent = tangent
        var elementTangents = TangentVector.zero
        elementTangents.reserveCapacity(count)
        for pullback in pullbacks.reversed() {
          let (newResultTangent, elementTangent) = pullback(resultTangent)
          resultTangent = newResultTangent
          elementTangents.append(elementTangent)
        }
        return (TangentVector(elementTangents.reversed()), resultTangent)
      }
    )
  }
  
  @inlinable
  @derivative(of: differentiableReduce)
  func _jvpDifferentiableReduce<Result: Differentiable>(
    _ initialResult: Result,
    _ nextPartialResult: @differentiable(reverse) (Result, Element) -> Result
  ) -> (
    value: Result,
    differential: (TangentVector, Result.TangentVector) -> Result.TangentVector)
  {
    var differentials:
      [(Result.TangentVector, Element.TangentVector) -> Result.TangentVector] =
        []
    differentials.reserveCapacity(count)
    var result = initialResult
    for element in self {
      let (y, df) =
        valueWithDifferential(at: result, element, of: nextPartialResult)
      result = y
      differentials.append(df)
    }
    return (value: result, differential: { dSelf, dInitial in
      var dResult = dInitial
      for (dElement, df) in zip(dSelf, differentials) {
        dResult = df(dResult, dElement)
      }
      return dResult
    })
  }
}

// ContiguousArray conformance

extension ContiguousArray: Differentiable
where Element: Differentiable & AdditiveArithmetic {}

extension ContiguousArray: DifferentiableCollection
where Element: Differentiable & AdditiveArithmetic {
  @inlinable
  public static var zero: ContiguousArray<Element> { .init() }
  
  public typealias ElementTangentCollection =
    ContiguousArray<Element.TangentVector>
  
  public typealias TangentVector =
    DifferentiableCollectionView<ElementTangentCollection>
}

extension ContiguousArray:
  DifferentiableRangeReplaceableCollection,
  DifferentiableBidirectionalCollection
where Element: Differentiable & AdditiveArithmetic {}

// ArraySlice conformance

extension ArraySlice: Differentiable
where Element: Differentiable & AdditiveArithmetic {}

extension ArraySlice: DifferentiableCollection
where Element: Differentiable & AdditiveArithmetic {
  @inlinable
  public static var zero: ArraySlice<Element> { .init() }
  
  public typealias ElementTangentCollection = ArraySlice<Element.TangentVector>
  
  public typealias TangentVector =
    DifferentiableCollectionView<ElementTangentCollection>
}

extension ArraySlice:
  DifferentiableRangeReplaceableCollection,
  DifferentiableBidirectionalCollection
where Element: Differentiable & AdditiveArithmetic {}

// Dictionary.Values conformance

extension Dictionary.Values: Differentiable
where Element: Differentiable & AdditiveArithmetic,
 Dictionary<Key, Value.TangentVector>.Index == Index /* this produces a warning diagnostic, but removing it causes a compilation failure on 5.5.2 */ {}

extension Dictionary.Values: DifferentiableCollection
where Element: Differentiable & AdditiveArithmetic,
Dictionary<Key, Value.TangentVector>.Index == Index /* this produces a warning diagnostic, but removing it causes a compilation failure on 5.5.2 */ {
  @inlinable
  public static var zero: Dictionary.Values {
    Dictionary<Key, Value>().values
  }

  public typealias ElementTangentCollection =
    Dictionary<Key, Value.TangentVector>.Values

  public typealias TangentVector =
    DifferentiableCollectionView<ElementTangentCollection>
}
