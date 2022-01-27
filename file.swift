import Swift

public protocol DifferentiableCollection: Collection {}

public struct DifferentiableCollectionView<Base: Collection> {
  // Will add conditional conformance to different collectionsby restricting
  // `Base`
  var _base: Base
}

extension DifferentiableCollection {
  typealias DifferentiableView = DifferentiableCollectionView<Self>
}

extension DifferentiableCollectionView {
  
}
