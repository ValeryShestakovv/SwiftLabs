import Foundation
import SnapKit
import UIKit

final class GalleryCellView: UICollectionViewCell {
    static let reuseId = "GalleryCollectionViewCell"
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let nameLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    weak var viewModel: GalleryCellViewModal? {
        didSet {
            self.nameLabel.text = viewModel?.hero.name
            if viewModel?.imageCache.image(withIdentifier: String((viewModel?.hero.id)!)) == nil {
                if viewModel?.connectedToNetwork == true {
                    viewModel?.downloadImage { [weak self] result in
                        guard let self = self else {return}
                        switch result {
                        case .success(let imageData):
                            if let image = UIImage(data: Data(referencing: imageData)) {
                                self.imageView.image = image
                                if let idHero = self.viewModel?.hero.id {
                                    self.viewModel?.imageCache.add(image,
                                                              withIdentifier: String(idHero))
                                }
                            } else {
                                self.imageView.image = UIImage(named: "placeholder")
                            }
                        case .failure(let error):
                            self.imageView.image = UIImage(named: "placeholder")
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                if let idHero = self.viewModel?.hero.id {
                    self.imageView.image = viewModel?.imageCache.image(withIdentifier: String(idHero))
                }
            }
        }
    }
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
