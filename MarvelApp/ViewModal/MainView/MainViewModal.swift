import Foundation
import RealmSwift

final class MainViewModel {
    private var listHeroes: [HeroModel] = []
    private var totalHeroes: Int?
    private let service = ServiceImp()
    let database = DBManager.realm()
    lazy var listHeroesDB: [HeroModel] = DBManager.getAllHeroes(realm: database!)
    var connectedToNetwork: Bool {
        if TestInternetConnection.connectedToNetwork() == true {
            return true
        } else {
            return false
        }
    }
    func getListHeroes(complition:@escaping () -> Void) {
        service.getListHeroes(offset: listHeroes.count, limit: 10) { [weak self] result, total in
            guard let self = self else {return}
            self.listHeroes = result
            self.totalHeroes = total
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
        service.getListHeroes(offset: 0, limit: listHeroes.count) { [weak self] result, _ in
            guard let self = self else {return}
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
    func getCurrentHeroModalDB(index: Int) -> HeroModel {
        return listHeroesDB[index]
    }
    func cellViewModel(index: Int) -> GalleryCellViewModal {
        if connectedToNetwork == true {
            return GalleryCellViewModal(hero: listHeroes[index])
        } else {
            return GalleryCellViewModal(hero: listHeroesDB[index])
        }
    }
    func detailViewModel(index: Int) -> DetailsHeroViewModal {
        if connectedToNetwork == true {
            return DetailsHeroViewModal(hero: listHeroes[index])
        } else {
            return DetailsHeroViewModal(hero: listHeroesDB[index])
        }
    }
    func addHeroToDB(hero: HeroModel) {
        DBManager.addHeroDB(realm: self.database, hero: hero)
    }
}
