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
        setupTextLayout()
    }
    func setupImageLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupTextLayout() {
        addSubview(nameLable)
        nameLable.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(40)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func compose(heroId: Int) {
        ServiceImp().getHero(idHero: heroId) { result in
            DispatchQueue.main.async {
                let resource = ImageResource(downloadURL: URL(string: result.image)!)
                let placeholder = UIImage(named: "placeholder")
                self.imageView.kf.setImage(with: resource, placeholder: placeholder)
                self.nameLable.text = result.name
            }
        }
    }
}
