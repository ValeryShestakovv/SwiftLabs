import Foundation

protocol ServiceProtocol {
    func getIdHeroes(completion: @escaping ([Int]) -> Void)
}
