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
    func downloadDetail(complition: @escaping(Result<HeroModel, Error>) -> Void) {
        service.getDetailsHero(idHero: self.hero.id) { result in
            if result != nil {
                complition(.success(result))
            } else {
                complition(.failure(ErrorHandler.errorDetails))
            }
        }
    }
    func downloadImage(complition:@escaping (Result<NSData, Error>) -> Void) {
        service.getImage(strURL: self.hero.imageStr) { result in
            if result != nil {
                complition(.success(result))
            } else {
                complition(.failure(ErrorHandler.errorImage))
            }
        }
    }
}
enum ErrorHandler: Error {
    case errorDetails
    case errorImage
}
extension ErrorHandler: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .errorDetails:
            return "Error download detail hero"
        case .errorImage:
            return "Error download image hero"
        }
    }
}
