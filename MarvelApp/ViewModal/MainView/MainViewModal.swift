import Foundation
import RealmSwift

final class MainViewModel {
    private var listHeroes: [HeroModel] = []
    private var totalHeroes: Int?
    private let service = ServiceImp()
    let database = DBManager.realm()
    var connectedToNetwork: Bool {
        if TestInternetConnection.connectedToNetwork() == true {
            return true
        } else {
            return false
        }
    }
    func getListHeroes(complition:@escaping () -> Void) {
        if connectedToNetwork == true {
            service.getListHeroes(offset: listHeroes.count, limit: 10) { [weak self] result, total in
                guard let self = self else {return}
                self.listHeroes = result
                self.totalHeroes = total
                complition()
            }
        } else {
            self.listHeroes = DBManager.getAllHeroes(realm: database!)
            complition()
        }
    }
    func getAddListHeroes(indexHero: Int, complition:@escaping () -> Void) {
        if listHeroes.count < totalHeroes ?? 0 && indexHero == listHeroes.count - 1 {
            service.getListHeroes(offset: listHeroes.count, limit: 10) { [weak self] result, _ in
                guard let self = self else {return}
                self.listHeroes.append(contentsOf: result)
                complition()
            }
        }
    }
    func refreshListHeroes(complition:@escaping () -> Void) {
        if connectedToNetwork == true {
            service.getListHeroes(offset: 0, limit: listHeroes.count) { [weak self] result, _ in
                guard let self = self else {return}
                self.listHeroes = result
                complition()
            }
        } else {
            self.listHeroes = DBManager.getAllHeroes(realm: database!)
            complition()
        }
    }
    func numberOfHeroes() -> Int {
        return listHeroes.count
    }
    func getCurrentHeroModal(index: Int) -> HeroModel {
        return listHeroes[index]
    }
    func addHeroToDB(hero: HeroModel) {
        DBManager.addHeroDB(realm: self.database, hero: hero)
    }
}
