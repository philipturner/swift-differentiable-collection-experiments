//
//  main.swift
//  Experimentation4
//
//  Created by Philip Turner on 1/27/22.
//

// By using Xcode 13.2.1 release toolchain + my Differentiation package, I can
// work around errors caused by RequirementMachine.
import Differentiation

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
  
  @inlinable // IDK if this is a good idea
  public mutating func move(by offset: TangentVector) {
    var view = DifferentiableView(self)
    view.move(by: offset)
    self = view.base
  }
}

public protocol DifferentiableCollectionViewProtocol: DifferentiableCollection {
  associatedtype Base: DifferentiableCollection
  
  var base: Base { get set }
  
  init(_ base: Base)
}

public struct DifferentiableCollectionView<Base: DifferentiableCollection>: DifferentiableCollectionViewProtocol {
  public typealias ElementTangentCollection = Base.ElementTangentCollection
  
  @usableFromInline // IDK if this is a good idea
  var _base: Base
}

extension DifferentiableCollectionView: DifferentiableCollection {
  public typealias Element = Base.Element
  public typealias Index = Base.Index
  
  @inlinable // IDK if this is a good idea
  public subscript(position: Index) -> Element {
    get {
      if position < endIndex {
        return base[position]
      } else {
        return Element.zero
      }
    }
    _modify {
      if position < endIndex {
        yield &base[position]
      } else {
        var zero = Element.zero
        yield &zero
      }
    }
  }
  
  @inlinable // IDK if this is a good idea
  public func index(after i: Index) -> Index {
    base.index(after: i)
  }
  
  @inlinable // IDK if this is a good idea
  public var startIndex: Index { base.startIndex }

  @inlinable // IDK if this is a good idea
  public var endIndex: Index { base.endIndex }
}

// MARK: - Declare conformances

extension DifferentiableCollectionView: Differentiable {
  /// The viewed array.
  @inlinable // IDK if this is a good idea
  public var base: Base {
    get { _base } // why can't we use `_read` here?
    _modify { yield &_base }
  }
  
  @inlinable // I changed a lot of instances of @usableFromInline to @inlinable. I'd rather not make a side note on every single example. Is there any reason not to do this?
  @derivative(of: base.get)
  func _vjpBase() -> (
    value: Base, pullback: (TangentVector) -> TangentVector
  ) {
    return (base, { $0 })
  }
  
  @inlinable
  @derivative(of: base.get)
  func _jvpBase() -> (
    value: Base, differential: (TangentVector) -> TangentVector
  ) {
    return (base, { $0 })
  }
  
  // TODO(SR-14113): add derivative of base._modify once that's supported
  // or make a derivative or base.set - is that a valid solution?
  
  /// Creates a differentiable view of the given array.
  @inlinable // IDK if this is a good idea
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
  
  @inlinable // IDK if this is a good idea
  public mutating func move(by offset: TangentVector) {
    if offset.isEmpty {
      return
    }
    precondition(
      count == offset.count, """
        Count mismatch: \(count) ('self') and \(offset.count) ('direction')
        """)
    
    for i in offset.indices {
      self[i].move(by: offset[i])
    }
  }
}

extension DifferentiableCollectionView: Equatable
where Element: Equatable {
  @inlinable // IDK if this is a good idea
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.elementsEqual(rhs)
  }
}

extension DifferentiableCollectionView: ExpressibleByArrayLiteral
where Base: RangeReplaceableCollection {
  @inlinable // IDK if this is a good idea
  public init(arrayLiteral elements: Element...) {
    self.init(Base(elements))
  }
}

// why is there only conformance for CustomStringConvertible and not CustomDebugStringConvertible or CustomReflectable?
extension DifferentiableCollectionView: CustomStringConvertible
where Base: CustomStringConvertible {
  @inlinable // IDK if this is a good idea
  public var description: String { base.description }
}

/// Makes `Array.DifferentiableView` additive as the product space.
///
/// Note that `Array.DifferentiableView([])` is the zero in the product spaces
/// of all counts.
extension DifferentiableCollectionView: AdditiveArithmetic
where Element: AdditiveArithmetic {
  @inlinable // IDK if this is a good idea
  public static var zero: Self { .init(Base.zero) }
  
  @inlinable // IDK if this is a good idea
  public static func + (lhs: Self, rhs: Self) -> Self {
    if lhs.count == 0 {
      return rhs
    }
    if rhs.count == 0 {
      return lhs
    }
    precondition(
      lhs.count == rhs.count,
      "Count mismatch: \(lhs.count) and \(rhs.count)")
    var sum = lhs
    for i in lhs.base.indices {
      sum[i] += rhs[i]
    }
    return sum
  }
  
  @inlinable // IDK if this is a good idea
  public static func - (lhs: Self, rhs: Self) -> Self {
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

// MARK: - DifferentiableRangeReplaceableCollection

public protocol DifferentiableRangeReplaceableCollection:
  DifferentiableCollection, RangeReplaceableCollection
where
  TangentVector: RangeReplaceableCollection,
  ElementTangentCollection: RangeReplaceableCollection {}

extension DifferentiableCollectionView: RangeReplaceableCollection
where Base: RangeReplaceableCollection {
  @inlinable // IDK if this is a good idea
  public init() {
    self.init(Base.zero)
  }
  
  @inlinable // IDK if this is a good idea
  public subscript(bounds: Range<Index>) -> Base.SubSequence {
    get { base[bounds] }
  }
  
  @inlinable // IDK if this is a good idea
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
  ElementTangentCollection: BidirectionalCollection {}

extension DifferentiableCollectionView: BidirectionalCollection
where Base: BidirectionalCollection {
  @inlinable // IDK if this is a good idea
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
        This should never happen. \
        \(Self.self) must override the default implementation of \
        `subscript(position:)` when conforming to `DifferentiableCollection`.
        """)
    }
    _modify {
      fatalError("""
        This should never happen. \
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
  
  // TODO(SR-14113): add derivative of subscript._modify once that's supported
  // or make a derivative or subscript.set - is that a valid solution?
}

extension DifferentiableRangeReplaceableCollection {
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
  where Element == Other.Element {
    fatalError("""
      This should never happen. \
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
  where Element == Other.Element {
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
        TangentVector(.init(v[..<lhs.endIndex])),
        Other.TangentVector(.init(v[lhs.endIndex...]))
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
  where Element == Other.Element {
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

// could be the other way around; extending Diff...Bidirectional... when Self
// is Diff...RangeReplaceable. The alternative is a clunky
// Diff...RangeReplaceable...Bidirectional... protocol. What should I do?
extension DifferentiableRangeReplaceableCollection
where Self: DifferentiableBidirectionalCollection {
  @_disfavoredOverload
  public mutating func append(_ newElement: Element) {
    fatalError("""
      This should never happen. \
      \(Self.self) must override the default implementation of `append(_:)` \
      when conforming to `DifferentiableCollection`.
      """)
  }
  
  @inlinable
  @derivative(of: append(_:))
  mutating func _vjpAppend(_ element: Element) -> (
    value: Void, pullback: (inout TangentVector) -> Element.TangentVector
  ) {
    append(element)
    return ((), { v in
      guard let lastElement = v.popLast() else {
        fatalError("This should never happen.") // should I put something else here?
      }
      return lastElement
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
  // a LOT more overloading of behavior of sequences' methods
  
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
      This should never happen. \
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
  where Element == Other.Element, Other: DifferentiableBidirectionalCollection {
    let lhsCount = lhs.count
    lhs += rhs
    return ((), { v in
      let drhs = Other.TangentVector(.init(v.dropFirst(lhsCount)))
      let rhsCount = drhs.count
      v.removeLast(rhsCount)
      return drhs
    })
  }
  
  @inlinable
  @derivative(of: +=)
  static func _jvpAppend<Other: DifferentiableRangeReplaceableCollection>(
    _ lhs: inout Self,
    _ rhs: Other
  ) -> (
    value: Void,
    differential: (inout TangentVector, Other.TangentVector) -> Void
  )
  where Element == Other.Element, Other: DifferentiableBidirectionalCollection {
    lhs += rhs
    return ((), { $0 += $1 })
  }
}

extension DifferentiableRangeReplaceableCollection {
  @_disfavoredOverload
  public init(repeating: Element, count: Int) {
    fatalError("""
      This should never happen. \
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

// could be the other way around; extending Diff...Bidirectional... when Self
// is Diff...RangeReplaceable. The alternative is a clunky
// Diff...RangeReplaceable...Bidirectional... protocol. What should I do?
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
