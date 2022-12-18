import Foundation
import Realm
import RealmSwift

public class DBManager {
    static func realm() -> Realm? {
        do {
            let config = Realm.Configuration(
              schemaVersion: 0,
              deleteRealmIfMigrationNeeded: true
            )
            Realm.Configuration.defaultConfiguration = config
            let realm = try Realm()
            return realm
        } catch let error {
            print("Could not access database: ", error)
            return nil
        }
    }
    static func addObjectDB<T: RealmSwiftObject>(realm: Realm?, hero: T) {
        do {
            try realm?.write {
                realm?.add(hero, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    static func getAllObjects<T: RealmSwiftObject>(realm: Realm) -> Results<T> {
        return realm.objects(T.self)
    }
    static func addHeroDB(realm: Realm?, hero: HeroModel) {
        do {
            let heroDB = HeroModelDB(dtoHeroModel: hero)
            try realm?.write {
                realm?.add(heroDB, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    static func getAllHeroes(realm: Realm) -> [HeroModel] {
        let objects = realm.objects(HeroModelDB.self)
        var listHero: [HeroModel] = []
        objects.forEach { heroDB in
            let hero = HeroModel(dtoHeroModelDB: heroDB)
            listHero.append(hero)
        }
        return listHero
    }
}
extension HeroModelDB {
    convenience init(dtoHeroModel: HeroModel) {
        self.init(
            name: dtoHeroModel.name,
            details: dtoHeroModel.details,
            imageData: NSData(data: dtoHeroModel.image.jpegData(compressionQuality: 1) ?? Data()),
            imageStr: dtoHeroModel.imageStr,
            idHero: dtoHeroModel.id
        )
    }
}
extension HeroModel {
    init(dtoHeroModelDB: HeroModelDB) {
        self.init(
            id: dtoHeroModelDB.idHero,
            imageStr: dtoHeroModelDB.imageStr,
            image: UIImage(data: dtoHeroModelDB.imageData as Data) ?? UIImage(),
            name: dtoHeroModelDB.name,
            details: dtoHeroModelDB.details
        )
    }
}
