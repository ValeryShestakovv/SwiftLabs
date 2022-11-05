import Foundation
import Alamofire
import UIKit

struct HeroListUpruv: Decodable {
    let data: HeroList
    enum CodingKeys: String, CodingKey {
        case data
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
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
    }
}

struct Thumbnail: Decodable {
    let imagePath: String
    enum CodingKeys: String, CodingKey {
        case imagePath = "path"
    }
}

class ServiceImp: ServiceProtocol {
    func getHero(idHero: Int, completion: @escaping (HeroModel) -> Void) {
        let URL = "https://gateway.marvel.com:443/v1/public/characters/"
        let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
        let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
        let timestamp = String(Date().timeStamp)
        let hash = timestamp + privateKey + publicKey
        let paramForListOfHeroes = URL + "\(idHero)" + "?ts=" + timestamp +
        "&apikey=" + publicKey + "&hash=" + hash.MD5value
        AF.download(paramForListOfHeroes).responseDecodable(of: HeroListUpruv.self) {response in
            guard let heroes = response.value else {return}
            let infoHeroes = heroes.data.result
            let imageURL = infoHeroes[0].thumbnail.imagePath + ".jpg"
            var heroModel = HeroModel(image: imageURL,
                                      name: infoHeroes[0].name,
                                      details: infoHeroes[0].description)
            completion(heroModel)
        }
    }
    func getIdHeroes(completion: @escaping ([Int]) -> Void) {
        let URL = "https://gateway.marvel.com:443/v1/public/characters"
        let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
        let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
        let timestamp = String(Date().timeStamp)
        let hash = timestamp + privateKey + publicKey
        let paramForListOfHeroes = URL + "?ts=" + timestamp +
        "&apikey=" + publicKey + "&hash=" + hash.MD5value
        AF.download(paramForListOfHeroes).responseDecodable(of: HeroListUpruv.self) {response in
            guard let heroes = response.value else {return}
            let result = heroes.data.result
            var heroIdList = [Int]()
            for index in 0...result.count-1 {
                heroIdList.append(result[index].id)
            }
            completion(heroIdList)
        }
    }
    func getImages(with strURL:String, completion: @escaping (UIImage) -> Void) {
        AF.request(strURL).responseData { response in
            guard let image = UIImage(data: response.data ?? Data()) else {return}
            completion(image)
        }
    }
}
