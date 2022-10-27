import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    public let imageHero: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleToFill
        return logo
    }()
    
    public let nameHero: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    public let detailHero: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageLayout()
        setupNameLayout()
        setupDetailLayout()
    }
    
    func setupImageLayout() {
        view.addSubview(imageHero)
        imageHero.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupNameLayout() {
        view.addSubview(nameHero)
        nameHero.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Layout.horizontalInset)
            make.bottom.equalToSuperview().inset(Layout.verticalInset)
        }
    }
    func setupDetailLayout() {
        view.addSubview(detailHero)
        detailHero.snp.makeConstraints { make in
            make.top.equalTo(nameHero.snp.top).inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.bottom.equalToSuperview().inset(Layout.horizontalInset)
        }
    }
}

extension DetailViewController {
    
    enum Layout {
        static var horizontalInset: CGFloat { 50 }
        static var verticalInset: CGFloat { 100 }
    }
}
