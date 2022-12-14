import Foundation

final class DetailsHeroViewModal {
    var imageData: NSData
    let imageString: String
    let nameString: String
    let discriptionString: String
    let id: Int
    private let service = ServiceImp()
    var connectedToNetwork: Bool {
        if TestInternetConnection.connectedToNetwork() == true {
            return true
        } else {
            return false
        }
    }
    required init(hero: HeroModel) {
        self.imageData = NSData()
        self.imageString = hero.imageStr
        self.nameString = hero.name
        self.discriptionString = hero.details
        self.id = hero.id
    }
    required init(hero: HeroModelDB) {
        self.imageData = hero.image
        self.imageString = ""
        self.nameString = hero.name
        self.discriptionString = hero.discription
        self.id = Int(hero.idHero)!
    }
    func downloadDetail(complition: @escaping(HeroModel) -> Void) {
        service.getDetailsHero(idHero: self.id) { result in
            complition(result)
        }
    }
    func downloadImage(complition:@escaping (NSData) -> Void) {
        service.getImage(strURL: self.imageString) { result in
            complition(result)
        }
    }
}
