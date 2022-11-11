import Foundation
import SnapKit
import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let textLable: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    var color: UIColor = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageLayout()
        setupTextLayout()
    }
    
    func setupImageLayout() {
        addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupTextLayout() {
        addSubview(textLable)
        textLable.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
