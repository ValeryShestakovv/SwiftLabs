import Foundation

protocol ServiceProtocol {
    func getListHeroes(completion: @escaping ([HeroModel]) -> Void)
}
