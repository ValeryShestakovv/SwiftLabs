import Foundation
import Alamofire
import AlamofireImage
import UIKit

final class ServiceImp: ServiceProtocol {
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
    func getDetailsHero(idHero: Int, completion: @escaping (HeroModel) -> Void) {
        AF.request(endpoint(path: "characters/" + String(idHero)),
                   method: .get,
                   parameters: getParams(offset: 0, limit: 1),
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
    func getListHeroes(offset: Int, limit: Int, completion: @escaping ([HeroModel], Int) -> Void) {
        AF.request(endpoint(path: "characters"),
                    method: .get,
                    parameters: getParams(offset: offset, limit: limit),
                    encoder: URLEncodedFormParameterEncoder(destination: .queryString))
        .responseDecodable(of: HeroListUpruvPayload.self) {response in
            guard let heroPayload = response.value?.data?.results,
                  let totalHeroes = response.value?.data?.total else {
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
        }
    }
    func getImage(strURL: String, complition: @escaping (NSData) -> Void) {
        AF.request(strURL + ".jpg").responseImage { response in
            if case .success(let image) = response.result {
                let imageData = NSData(data: (image.jpegData(compressionQuality: 1) ?? Data()))
                complition(imageData)
            }
        }
    }
}
extension HeroModel {
    init(dtoHero: HeroPayload) {
        self.init(
            id: dtoHero.id ?? 0,
            imageStr: dtoHero.thumbnail?.imagePath ?? "",
            imageData: NSData(),
            name: dtoHero.name ?? "",
            details: dtoHero.description ?? ""
        )
    }
}
