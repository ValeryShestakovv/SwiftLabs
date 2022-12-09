import Foundation
import SnapKit
import UIKit
import Kingfisher

final class GalleryCollectionViewCell: UICollectionViewCell {
    static let reuseId = "GalleryCollectionViewCell"
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let nameLable: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageLayout()
        setupNameLayout()
    }
    private func setupImageLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupNameLayout() {
        addSubview(nameLable)
        nameLable.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.left.right.bottom.equalToSuperview().inset(40)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    func compose(hero: HeroModel) {
//        guard let imageUrl = URL(string: hero.imageStr + ".jpg") else { return }
//        let resource = ImageResource(downloadURL: imageUrl)
//        let placeholder = UIImage(named: "placeholder")
//        nameLable.text = hero.name
//        imageView.kf.setImage(with: resource, placeholder: placeholder) { _ in
//            let heroModel = HeroModelDB(name: hero.name,
//                                        discription: hero.details,
//                                        image: self.imageView.image ?? UIImage(),
//                                        idHero: hero.id)
//            DBManager.addObjectDB(realm: database, hero: heroModel)
//        }
//    }
}
