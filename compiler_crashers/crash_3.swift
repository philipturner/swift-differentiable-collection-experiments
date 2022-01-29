import _Differentiation

// WORKAROUND: add '-Xfrontend -validate-tbd-against-ir=none' to squash the errors

protocol DifferentiableCollection: Collection & Differentiable
where Element: Differentiable {}

extension DifferentiableCollection {
  init(repeating: Element, count: Int) {
    fatalError()
  }
  
  @derivative(of: init(repeating:count:))
  static func _vjpInit(repeating repeatedValue: Element, count: Int) -> (
    value: Self, pullback: (TangentVector) -> Element.TangentVector
  ) {
    fatalError()
  }
  // FIXED when this is no longer commented out
//  @usableFromInline
//  @derivative(of: init(repeating:count:))
//  static func _jvpInit(repeating repeatedValue: Element, count: Int) -> (
//    value: Self, differential: (Element.TangentVector) -> TangentVector
//  ) {
//    fatalError()
//  }
}

/*
 <unknown>:0: error: symbol '$s16Experimentation424DifferentiableCollectionPAAE9repeating5countx7ElementQz_SitcfCAaBRzlTJfSUUpSr' (forward-mode derivative of (extension in Experimentation4):Experimentation4.DifferentiableCollection.init(repeating: A.Element, count: Swift.Int) -> A with respect to parameters {0} and results {0} with <A where A: Experimentation4.DifferentiableCollection>) is in generated IR file, but not in TBD file
 <unknown>:0: error: please submit a bug report (https://swift.org/contributing/#reporting-bugs) and include the project, and add '-Xfrontend -validate-tbd-against-ir=none' to squash the errors
 */
