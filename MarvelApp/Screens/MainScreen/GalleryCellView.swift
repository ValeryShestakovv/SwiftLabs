import Foundation
import SnapKit
import UIKit
import Kingfisher

final class GalleryCellView: UICollectionViewCell {
    static let reuseId = "GalleryCollectionViewCell"
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    private let activityView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

        view.addSubview(blurEffect)
        view.addSubview(activityIndicator)
        blurEffect.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageLayout()
        setupNameLayout()
        setupActivityLayout()
    }
    private func setupActivityLayout() {
        addSubview(activityView)
        activityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityView.alpha = 0
    }
    private func showSpinner() {
        UIView.animate(withDuration: 0.5) {
            self.activityView.alpha = 1
        }
    }
    private func removeSpinner() {
        UIView.animate(withDuration: 0.5) {
            self.activityView.alpha = 0
        }
    }
    func setupHero(_ hero: HeroModel, complition: @escaping(HeroModel) -> Void) {
        nameLabel.text = hero.name
        guard let imageURL = URL(string: hero.imageStr) else {return}
        let resource = ImageResource(downloadURL: imageURL)
        showSpinner()
        imageView.kf.setImage(with: resource, placeholder: UIImage(named: "placeholder")) { _ in
            self.removeSpinner()
            guard let image = self.imageView.image else {return}
            let heroDB = HeroModel(id: hero.id,
                                   imageStr: hero.imageStr,
                                   image: image,
                                   name: hero.name,
                                   details: hero.details)
            complition(heroDB)
        }
    }
    func setupHeroDB( _ hero: HeroModel) {
        nameLabel.text = hero.name
        imageView.image = hero.image
    }
    private func setupImageLayout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupNameLayout() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.left.right.bottom.equalToSuperview().inset(40)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
