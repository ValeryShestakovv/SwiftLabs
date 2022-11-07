import Foundation
import UIKit

struct HeroModel: Stubable {
    var imageStr: String
    var name: String
    var details: String
    static let stub: HeroModel = .init(imageStr: "", name: "", details: "")
}

protocol Stubable {
    static var stub: Self { get }
}
