import RealmSwift

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch {
            // LOG ERROR
            return nil
        }
    }
}
