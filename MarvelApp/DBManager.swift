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
}
