import Swift

public protocol DiffColParent: Collection where Element: Differentiable {
  associatedtype SelfOfElemTan: DifferentiableCollection
}


public protocol DiffColParent2: DiffColParent where SelfOfElemTan.Element == Element.TangentVector {
  //  associatedtype SelfOfElementTangent: Collection & Differentiable & DifferentiableCollection
}

public protocol DifferentiableCollection: DiffColParent2 {
  associatedtype DifferentiableView: Differentiable
}

//public protocol DiffColViewTraits { // just need to be able to constrain this so that the base's type is the same as the DifferentiableView's container's type!
//  associatedtype Base: Collection
//  var base: Base { get set }
//}

public extension DifferentiableCollection {
  typealias TangentVector = Self.SelfOfElemTan.DifferentiableView
}




public struct DifferentiableCollectionView<Base: DifferentiableCollection>: Differentiable {
  // Will add conditional conformance to different collectionsby restricting
  // `Base`
  @noDerivative var _base: Base
  
  /// The viewed collection.
  public var base: Base {
    get { _base }
    _modify { yield &_base }
  }
  
  // try changing to @inlinable
  @usableFromInline
  @derivative(of: base)
  func _vjpBase() -> (
    value: Base, pullback: (Base.TangentVector) -> TangentVector
  ) {
    return (base, { $0 })
  }
  
  @usableFromInline
  @derivative(of: base)
  func _jvpBase() -> (
    value: Base, differential: (Base.TangentVector) -> TangentVector
  ) {
    return (base, { $0 })
  }
  
  /// Creates a differentiable view of the given array.
  public init(_ base: Base) { self._base = base }

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
  
  public typealias TangentVector = Base.SelfOfElemTan.DifferentiableView
  
  public mutating func move(by offset: TangentVector) {
    if offset.base.isEmpty {
      return
    }
    precondition(
      base.count == offset.base.count, """
        Count mismatch: \(base.count) ('self') and \(offset.base.count) \
        ('direction')
        """)
    for i in offset.base.indices {
      base[i].move(by: offset.base[i])
    }
  }
}

public extension DifferentiableCollection {
  typealias DifferentiableView = DifferentiableCollectionView<Self>
}
