import Foundation
import UIKit

struct HeroModel: Stubable {
    var id: Int
    var imageStr: String
    var name: String
    var details: String
    static let stub: HeroModel = .init(id: 0, imageStr: "", name: "", details: "")
}

protocol Stubable {
    static var stub: Self { get }
}
