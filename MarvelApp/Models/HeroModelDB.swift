import Foundation
import RealmSwift

class HeroModelDB: Object {
    @objc dynamic var name = ""
    @objc dynamic var details = ""
    @objc dynamic var imageData = NSData()
    @objc dynamic var imageStr = ""
    @objc dynamic var idHero = 0
    override static func primaryKey() -> String? {
      return "idHero"
    }
    convenience init(name: String, details: String, imageData: NSData, imageStr: String, idHero: Int) {
        self.init()
        self.name = name
        self.details = details
        self.imageData = imageData
        self.imageStr = imageStr
        self.idHero = idHero
    }
}
