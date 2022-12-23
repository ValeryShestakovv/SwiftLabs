import Foundation

final class DetailsHeroViewModal {
    var hero: HeroModel
    private let service = HeroServiceImpl()
    var connectedToNetwork: Bool {
        if TestInternetConnection.connectedToNetwork() == true {
            return true
        } else {
            return false
        }
    }
    required init(hero: HeroModel) {
        self.hero = hero
    }
    func downloadDetails(complition: @escaping(Result<HeroModel, Error>) -> Void) {
        service.getDetailsHero(idHero: self.hero.id) { result in
            switch result {
            case .success(let value):
                complition(.success(value))
            case .failure(let error):
                complition(.failure(error))
            }
            complition(result)
        }
    }
}
