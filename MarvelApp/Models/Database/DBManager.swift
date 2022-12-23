import Foundation
import Realm
import RealmSwift

protocol DBManager: AnyObject {
    func addHeroDB(hero: HeroModel)
    func getAllHeroes() -> [HeroModel]
}

final class DBManagerImpl: DBManager {
    private let realm: Realm?
    init() {
        do {
            let config = Realm.Configuration(
              schemaVersion: 0,
              deleteRealmIfMigrationNeeded: true
            )
            Realm.Configuration.defaultConfiguration = config
            let realm = try Realm()
            self.realm = realm
        } catch let error {
            print("Could not access database: ", error)
            self.realm = nil
        }
    }
    func addObjectDB<T: RealmSwiftObject>(hero: T) {
        do {
            try realm?.write {
                realm?.add(hero, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    func getAllObjects<T: RealmSwiftObject>() -> Results<T> {
        return realm!.objects(T.self)
    }
    func addHeroDB(hero: HeroModel) {
        do {
            let heroDB = HeroModelDB(dtoHeroModel: hero)
            try realm?.write {
                realm?.add(heroDB, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    func getAllHeroes() -> [HeroModel] {
        let objects = realm?.objects(HeroModelDB.self)
        var listHero: [HeroModel] = []
        objects?.forEach { heroDB in
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
