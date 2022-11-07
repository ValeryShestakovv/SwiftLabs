import Foundation
import Alamofire
import UIKit

struct HeroListUpruvPayload: Decodable {
    let data: HeroListPayload?
}

struct HeroListPayload: Decodable {
    let count: Int?
    let results: [HeroPayload]?
}

struct HeroPayload: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: ThumbnailPayload?
}

struct ThumbnailPayload: Decodable {
    let imagePath: String?
    enum CodingKeys: String, CodingKey {
        case imagePath = "path"
    }
}

class ServiceImp: ServiceProtocol {
    func getHero(idHero: Int, completion: @escaping (HeroModel) -> Void) {
        let URL = "https://gateway.marvel.com/v1/public/characters/"
        let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
        let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
        let timestamp = String(Date().timeStamp)
        let hash = timestamp + privateKey + publicKey
        let paramForListOfHeroes = URL + "\(idHero)" + "?ts=" + timestamp +
        "&apikey=" + publicKey + "&hash=" + hash.MD5value
        AF.request(paramForListOfHeroes,
                   method: .get)
        .responseDecodable(of: HeroListUpruvPayload.self) { response in
            guard let heroPayload = response.value?.data?.results?[0] else {
                completion(.stub)
                return
            }
            let heroModel = HeroModel(dtoHero: heroPayload)
            completion(heroModel)
        }
    }
    func getIdHeroes(completion: @escaping ([Int]) -> Void) {
        let URL = "https://gateway.marvel.com/v1/public/characters"
        let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
        let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
        let timestamp = String(Date().timeStamp)
        let hash = timestamp + privateKey + publicKey
        let paramForListOfHeroes = URL + "?ts=" + timestamp +
        "&apikey=" + publicKey + "&hash=" + hash.MD5value
        AF.download(paramForListOfHeroes)
            .responseDecodable(of: HeroListUpruvPayload.self) {response in
                guard let heroPayload = response.value?.data?.results else {
                completion([])
                return
            }
            var heroIdList = [Int]()
            for index in 0...heroPayload.count-1 {
                guard let idHero = heroPayload[index].id else {
                    continue
                }
                heroIdList.append(idHero)
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

extension HeroModel {
    init(dtoHero: HeroPayload) {
        self.init(
            imageStr: dtoHero.thumbnail?.imagePath ?? "",
            name: dtoHero.name ?? "",
            details: dtoHero.description ?? ""
        )
    }
}
