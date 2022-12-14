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
    func downloadImage(complition:@escaping (Result<NSData, Error>) -> Void) {
        service.getImage(strURL: self.hero.imageStr) { [weak self] result in
            if result != nil {
                self?.mainViewModel?.addHeroToDB(hero: self!.hero)
                complition(.success(result))
            } else {
                complition(.failure(ErrorHandler.errorImage))
            }
        }
    }
}
