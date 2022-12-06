import Foundation

class GalleryCellViewModal {
    var imageData: NSData
    let imageString: String
    let nameString: String
    let discriptionString: String
    let id: Int
    private let service = ServiceImp()
    weak var mainViewModel: MainViewModel!
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
    func downloadImage(complition:@escaping (NSData) -> Void) {
        service.getImage(strURL: self.imageString) { result in
            let heroModel = HeroModelDB(name: self.nameString,
                                        discription: self.discriptionString,
                                        image: result,
                                        idHero: self.id)
            self.mainViewModel.addHeroToDB(hero: heroModel)
            complition(result)
        }
    }
}
