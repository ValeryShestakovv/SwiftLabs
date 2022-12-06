import Foundation

protocol ServiceProtocol: AnyObject {
    func getDetailsHero(idHero: Int, completion: @escaping (HeroModel) -> Void)
    func getListHeroes(offset: Int, limit: Int, completion: @escaping ([HeroModel], Int) -> Void)
}
