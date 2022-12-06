import Foundation
import RealmSwift

class HeroModelDB: Object {
    @objc dynamic var name = ""
    @objc dynamic var discription = ""
    @objc dynamic var image = NSData()
    @objc dynamic var idHero = ""
    override static func primaryKey() -> String? {
      return "idHero"
    }
    convenience init(name: String, discription: String, image: NSData, idHero: Int) {
        self.init()
        self.name = name
        self.discription = discription
        self.image = image
        self.idHero = String(idHero)
    }
}
