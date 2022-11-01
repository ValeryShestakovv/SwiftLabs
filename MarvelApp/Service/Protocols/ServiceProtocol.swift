import Foundation

protocol ServiceProtocol {
    func getHeroes(completion: @escaping ([HeroModel]) -> Void)
}
