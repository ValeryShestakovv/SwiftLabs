import Foundation
import RealmSwift

private let realm = try! Realm()

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
func addObjectDB(hero: HeroModelDB) {
        try! realm.write({
            realm.add(hero, update: .modified)
        })
}
func getAllObjectsDB() -> Results<HeroModelDB> {
    return realm.objects(HeroModelDB.self)
}
