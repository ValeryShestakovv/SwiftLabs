import Foundation
import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let textLable: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    var color: UIColor = .red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        addSubview(textLable)
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        textLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
