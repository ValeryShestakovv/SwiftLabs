import Foundation
import Alamofire
import AlamofireImage
import UIKit

protocol HeroService: AnyObject {
    func getDetailsHero(idHero: Int, completion: @escaping (Result<HeroModel, Error>) -> Void)
    func getListHeroes(offset: Int, limit: Int, completion: @escaping ([HeroModel], Int) -> Void)
}

final class HeroServiceImpl: HeroService {
    private let baseUrl = "https://gateway.marvel.com/v1/public/"
    private let privateKey = "94b698d025f8a1363b1e43cb1f2982c64d3d56af"
    private let publicKey = "a6b4166234aa5492bf43f028bcbb94d1"
    private let timestamp = String(Date().timeStamp)
    private func endpoint(path:String) -> String {
        return baseUrl + path
    }
    private func getParams(offset: Int, limit: Int) -> [String: String] {
        let hash = timestamp + privateKey + publicKey
        let parameters: [String: String] = [
            "limit": "\(limit)",
            "offset": "\(offset)",
            "ts": "\(timestamp)",
            "apikey": "\(publicKey)",
            "hash": "\(hash.MD5value)"
        ]
        return parameters
    }
    func getDetailsHero(idHero: Int, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        AF.request(endpoint(path: "characters/" + String(idHero)),
                   method: .get,
                   parameters: getParams(offset: 0, limit: 1),
                   encoder: URLEncodedFormParameterEncoder(destination: .queryString))
        .responseDecodable(of: HeroListUpruvPayload.self) { response in
            switch response.result {
            case .success(let value):
                guard let heroPayload = value.data?.results?[0] else {
                    completion(.success(.stub))
                    return
                }
                let heroModel = HeroModel(dtoHero: heroPayload)
                completion(.success(heroModel))
            case .failure(let error):
                print("Error while request details hero: \(error)")
                completion(.failure(error))
            }
        }
    }
    func getListHeroes(offset: Int, limit: Int, completion: @escaping ([HeroModel], Int) -> Void) {
        AF.request(endpoint(path: "characters"),
                    method: .get,
                    parameters: getParams(offset: offset, limit: limit),
                    encoder: URLEncodedFormParameterEncoder(destination: .queryString))
        .responseDecodable(of: HeroListUpruvPayload.self) {response in
            switch response.result {
            case .success(let value):
                guard let heroPayload = value.data?.results,
                      let totalHeroes = value.data?.total else {
                    completion([], 0)
                    return
                }
                var heroIdList = [HeroModel]()
                for index in 0...heroPayload.count-1 {
                    guard heroPayload[index].id != nil else {
                        continue
                    }
                    heroIdList.append(HeroModel(dtoHero: heroPayload[index]))
                }
                completion(heroIdList, totalHeroes)
            case .failure(let error):
                print("Error while request list heroes: \(error)")
                completion([], 0)
            }
        }
    }
}
extension HeroModel {
    init(dtoHero: HeroPayload) {
        self.init(
            id: dtoHero.id ?? 0,
            imageStr: (dtoHero.thumbnail?.imagePath ?? "") + "." + (dtoHero.thumbnail?.imageExtension ?? ""),
            image: UIImage(),
            name: dtoHero.name ?? "",
            details: dtoHero.description ?? ""
        )
    }
}
