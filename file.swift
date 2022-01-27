import Swift

public protocol DiffColParent: Collection & Differentiable


public protocol DifferentiableCollection: Collection & Differentiable where Element: Differentiable {
  associatedtype DifferentiableView: Differentiable
//  associatedtype SelfOfElementTangent: Collection & Differentiable & DifferentiableCollection
}

public extension DifferentiableCollection {
  typealias TangentVectorq = Self.DifferentiableView
}




public struct DifferentiableCollectionView<Base: DifferentiableCollection> {
  // Will add conditional conformance to different collectionsby restricting
  // `Base`
  @noDerivative var _base: Base
}

public extension DifferentiableCollection {
  typealias DifferentiableView = DifferentiableCollectionView<Self>
}

extension DifferentiableCollectionView: Differentiable
where Base.Element: Differentiable {
  /// The viewed collection.
  public var base: Base {
    get { _base }
    _modify { yield &_base }
  }
  
  // try changing to @inlinable
  @usableFromInline
  @derivative(of: base)
  func _vjpBase() -> (
    value: Base, pullback: (Base.TangentVectorq) -> TangentVector
  ) {
    return (base, { $0 })
  }
  
  public typealias TangentVector = Base.TangentVectorq
  
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

