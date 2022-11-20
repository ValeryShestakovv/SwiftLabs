import Foundation
import RealmSwift

public class DBManager {
    static func addObjectDB(realm: Realm?, hero: HeroModelDB) {
        do {
            try realm?.write {
                realm?.add(hero, update: .modified)
            }
        } catch let error {
            print(error)
        }
    }
    static func getAllObjects(realm: Realm) -> Results<HeroModelDB> {
        return realm.objects(HeroModelDB.self)
    }
}
