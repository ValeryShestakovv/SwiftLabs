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
    convenience init(name: String, discription: String, image: UIImage, idHero: Int) {
        self.init()
        self.name = name
        self.discription = discription
        self.image = NSData(data: image.jpegData(compressionQuality: 1)!)
        self.idHero = String(idHero)
    }
}
