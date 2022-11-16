import Foundation

protocol ServiceProtocol {
    func getDetailsHero(idHero: Int, completion: @escaping (HeroModel) -> Void)
    func getListHeroes(offset: Int, completion: @escaping ([HeroModel], Int) -> Void)
}
