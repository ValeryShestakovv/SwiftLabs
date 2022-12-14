import Foundation

final class DetailsHeroViewModal {
    var hero: HeroModel
    private let service = ServiceImp()
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
    func downloadDetail(complition: @escaping(HeroModel) -> Void) {
        service.getDetailsHero(idHero: self.hero.id) { result in
            complition(result)
        }
    }
    func downloadImage(complition:@escaping (NSData) -> Void) {
        service.getImage(strURL: self.hero.imageStr) { result in
            complition(result)
        }
    }
}
