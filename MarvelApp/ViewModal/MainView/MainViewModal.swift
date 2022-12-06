import Foundation
import RealmSwift

class MainViewModel {
    private var listHeroes: [HeroModel] = []
    private var totalHeroes: Int?
    private let service = ServiceImp()
    let database = DBManager.realm()
    lazy var listHeroesDB: Results<HeroModelDB> = DBManager.getAllObjects(realm: database!)
    var connectedToNetwork: Bool {
        if TestInternetConnection.connectedToNetwork() == true {
            return true
        } else {
            return false
        }
    }
    func getListHeroes(complition:@escaping () -> Void) {
        service.getListHeroes(offset: listHeroes.count, limit: 10) { result, total in
            self.listHeroes = result
            self.totalHeroes = total
            complition()
        }
    }
    func getAddListHeroes(indexHero: Int, complition:@escaping () -> Void) {
        if listHeroes.count < totalHeroes ?? 0 && indexHero == listHeroes.count - 1 {
            service.getListHeroes(offset: listHeroes.count, limit: 10) { result, _ in
                self.listHeroes.append(contentsOf: result)
                complition()
            }
        }
    }
    func refreshListHeroes(complition:@escaping () -> Void) {
        service.getListHeroes(offset: 0, limit: listHeroes.count) { result, _ in
            self.listHeroes = result
            complition()
        }
    }
    func numberOfHeroes() -> Int {
        if connectedToNetwork == true {
            return listHeroes.count
        } else {
            return listHeroesDB.count
        }
    }
    func getCurrentHeroModal(index: Int) -> HeroModel {
        return listHeroes[index]
    }
    func getCurrentHeroModalDB(index: Int) -> HeroModelDB {
        return listHeroesDB[index]
    }
    func cellViewModel(index: Int) -> GalleryCellViewModal {
        if connectedToNetwork == true {
            return GalleryCellViewModal(hero: listHeroes[index])
        } else {
            return GalleryCellViewModal(hero: listHeroesDB[index])
        }
    }
    func detailViewModel(index: Int) -> DetailViewModal {
        if connectedToNetwork == true {
            return DetailViewModal(hero: listHeroes[index])
        } else {
            return DetailViewModal(hero: listHeroesDB[index])
        }
    }
    func addHeroToDB(hero: HeroModelDB) {
        DBManager.addObjectDB(realm: self.database, hero: hero)
    }
}
