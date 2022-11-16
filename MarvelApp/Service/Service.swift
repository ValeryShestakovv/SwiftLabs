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

final class ServiceImp: ServiceProtocol {
    private let baseUrl = "https://gateway.marvel.com/v1/public/"
    private let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
    private let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
    private let timestamp = String(Date().timeStamp)
    private func endpoint(path:String) -> String {
        return baseUrl + path
    }
    private func getParams() -> [String: String] {
        let hash = timestamp + privateKey + publicKey
        let parameters: [String: String] = [
            "ts": "\(timestamp)",
            "apikey": "\(publicKey)",
            "hash": "\(hash.MD5value)"
        ]
        return parameters
    }
    func getDetailsHero(idHero: Int, completion: @escaping (HeroModel) -> Void) {
        AF.request(endpoint(path: "characters/" + String(idHero)),
                   method: .get,
                   parameters: getParams(),
                   encoder: URLEncodedFormParameterEncoder(destination: .queryString))
        .responseDecodable(of: HeroListUpruvPayload.self) { response in
            guard let heroPayload = response.value?.data?.results?[0] else {
                completion(.stub)
                return
            }
            let heroModel = HeroModel(dtoHero: heroPayload)
            completion(heroModel)
        }
    }
    func getListHeroes(completion: @escaping ([HeroModel]) -> Void) {
        AF.download(endpoint(path: "characters"),
                    method: .get,
                    parameters: getParams(),
                    encoder: URLEncodedFormParameterEncoder(destination: .queryString))
            .responseDecodable(of: HeroListUpruvPayload.self) {response in
                guard let heroPayload = response.value?.data?.results else {
                completion([])
                return
            }
            var heroIdList = [HeroModel]()
            for index in 0...heroPayload.count-1 {
                guard let idHero = heroPayload[index].id else {
                    continue
                }
                heroIdList.append(HeroModel(dtoHero: heroPayload[index]))
            }
            completion(heroIdList)
        }
    }
}
extension HeroModel {
    init(dtoHero: HeroPayload) {
        self.init(
            id: dtoHero.id ?? 0,
            imageStr: dtoHero.thumbnail?.imagePath ?? "",
            name: dtoHero.name ?? "",
            details: dtoHero.description ?? ""
        )
    }
}
