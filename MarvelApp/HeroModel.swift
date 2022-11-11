import Foundation
import UIKit

struct HeroModel {
    var image: UIImage
    var name: String
    var color: UIColor
    
    static func fetchHero() -> [HeroModel] {
        let firstItem = HeroModel(image: UIImage(named: "ironman")!, name: "Iron Man", color: ColorHero.ironman)
        let secondItem = HeroModel(image: UIImage(named: "thor")!, name: "Thor", color: ColorHero.thor)
        let threeItem = HeroModel(image: UIImage(named: "halk")!, name: "Halk", color: ColorHero.halk)
        
        return [firstItem,secondItem,threeItem]
    }
}

struct ColorHero {
    static let ironman: UIColor = UIColor(red: 0.8078, green: 0, blue: 0, alpha: 1.0)
    static let thor: UIColor = UIColor(red: 0, green: 0.5647, blue: 0.8078, alpha: 1.0)
    static let halk: UIColor = UIColor(red: 0, green: 0.749, blue: 0.0353, alpha: 1.0)
}
