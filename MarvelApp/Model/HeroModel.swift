import Foundation
import UIKit

struct HeroModel: Stubable {
    let id: Int
    let imageStr: String
    var imageData: NSData
    let name: String
    let details: String
    static let stub: HeroModel = .init(id: 0, imageStr: "",imageData: NSData(), name: "", details: "")
}

protocol Stubable {
    static var stub: Self { get }
}
