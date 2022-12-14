import Foundation
import Realm
import RealmSwift

public class DBManager {
    static func realm() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch {
            // LOG ERROR
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
            let heroDB = HeroModelDB(dtoHeroModal: hero)
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
            let hero = HeroModel(dtoHeroDB: heroDB)
            listHero.append(hero)
        }
        return listHero
    }
}
extension HeroModelDB {
    convenience init(dtoHeroModal: HeroModel) {
        self.init(
            name: dtoHeroModal.name,
            details: dtoHeroModal.details,
            imageData: dtoHeroModal.imageData,
            imageStr: dtoHeroModal.imageStr,
            idHero: dtoHeroModal.id
        )
    }
}
extension HeroModel {
    init(dtoHeroDB: HeroModelDB) {
        self.init(
            id: dtoHeroDB.idHero,
            imageStr: dtoHeroDB.imageStr,
            imageData: dtoHeroDB.imageData,
            name: dtoHeroDB.name,
            details: dtoHeroDB.details
        )
    }
}
