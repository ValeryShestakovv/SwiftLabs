import Foundation
import Alamofire
import UIKit

struct HeroListUpruv: Decodable {
    let data: HeroList
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct HeroList: Decodable {
    let count: Int
    let result: [Hero]
    enum CodingKeys: String, CodingKey {
        case count
        case result = "results"
    }
}

struct Hero: Decodable {
    let name: String
    let description: String
    let thumbnail: Thumbnail
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
    }
}

struct Thumbnail: Decodable {
    let imagePath: String
    enum CodingKeys: String, CodingKey {
        case imagePath = "path"
    }
}

class ServiceImp: ServiceProtocol {
    func getHeroes(completion: @escaping ([HeroModel]) -> Void) {
        let URL = "https://gateway.marvel.com:443/v1/public/characters"
        let privateKey = "c4297647a4d0311748b4044750e47042d46b9c36"
        let publicKey = "f1b4e81f7a8676c1ad02514d1caa49d4"
        let timestamp = String(Date().timeStamp)
        let hash = timestamp + privateKey + publicKey
        let paramForListOfHeroes = URL + "?ts=" + timestamp + "&apikey=" + publicKey + "&hash=" + hash.MD5value

        AF.download(paramForListOfHeroes).responseDecodable(of: HeroListUpruv.self) {response in
            guard let heroes = response.value else {return}
            let infoHeroes = heroes.data.result
            var heroModel = [HeroModel]()
            for index in 0...infoHeroes.count-1 {
                let imageURL = infoHeroes[index].thumbnail.imagePath + ".jpg"
                heroModel.append(HeroModel(image: imageURL,
                                           name: infoHeroes[index].name,
                                           details: infoHeroes[index].description))
            }
            completion(heroModel)
        }
    }
    func getImages(with strURL:String, completion: @escaping (UIImage) -> Void) {
        AF.request(strURL).responseData { response in
            guard let image = UIImage(data: response.data ?? Data()) else {return}
            completion(image)
        }
    }
}
