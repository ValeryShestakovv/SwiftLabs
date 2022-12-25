import Foundation
import UIKit

struct HeroModel: Stubable {
    let id: Int
    let imageStr: String
    var image: UIImage
    let name: String
    let details: String
    static let stub: HeroModel = .init(id: 0, imageStr: "", image: UIImage(), name: "", details: "")
}

protocol Stubable {
    static var stub: Self { get }
}
