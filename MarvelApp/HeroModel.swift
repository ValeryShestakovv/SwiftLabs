import Foundation
import UIKit

struct HeroModel {
    let imageURL: URL
    let name: String
    let color: UIColor
    let discription: String
    static func fetchHero() -> [HeroModel] {
        let firstItem = HeroModel(imageURL: ImageUrlHero.ironman!,
                                  name: "Iron Man",
                                  color: ColorHero.ironman,
                                  discription: "I'm Iron Man! This is may discription!")
        let secondItem = HeroModel(imageURL: ImageUrlHero.thor!,
                                   name: "Thor",
                                   color: ColorHero.thor,
                                   discription: "I'm God of Thunder! This is may discription!")
        let threeItem = HeroModel(imageURL: ImageUrlHero.halk!,
                                  name: "Halk",
                                  color: ColorHero.halk,
                                  discription: "I'm Hulk! Crush! Crush! Crush!")
        return [firstItem,secondItem,threeItem]
    }
}

struct ColorHero {
    static let ironman: UIColor = UIColor(red: 0.8078, green: 0, blue: 0, alpha: 1.0)
    static let thor: UIColor = UIColor(red: 0, green: 0.5647, blue: 0.8078, alpha: 1.0)
    static let halk: UIColor = UIColor(red: 0, green: 0.749, blue: 0.0353, alpha: 1.0)
}
struct ImageUrlHero {
    static let ironman = URL(string: """
                             https://static.wikia.nocookie.net/marveldatabase/\
                             images/0/0a/Iron_Man_Vol_6_1_Brooks_Variant_Textless.jpg/\
                             revision/latest?cb=20211207231858
                             """)
    static let thor = URL(string: """
                          https://external-preview.redd.it/v0faxD1kIFgkMECiYdtnR8rw9FSJkK9noOKn2PzprCs.jpg\
                          ?width=640&crop=smart&auto=webp&s=f3e316b6408eb02776ddc3fdc840b564efeaaebe
                          """)
    static let halk = URL(string: """
                          https://comicvine.gamespot.com/a/uploads/scale_medium/\
                          12/124259/7892286-immortal_hulk_vol_1_38_.jpg
                          """)
}
