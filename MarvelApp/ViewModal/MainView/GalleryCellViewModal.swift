import Foundation

final class GalleryCellViewModal {
    var hero: HeroModel
    private let service = ServiceImp()
    weak var mainViewModel: MainViewModel?
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
    func downloadImage(complition:@escaping (NSData) -> Void) {
        service.getImage(strURL: self.hero.imageStr) { result in
            self.hero.imageData = result
            self.mainViewModel?.addHeroToDB(hero: self.hero)
            complition(result)
        }
    }
}
