import UIKit
import SnapKit

final class DetailViewController: UIViewController {

    let imageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleToFill
        return logo
    }()
    let nameLable: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let detailLable: UILabel = {
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
    private func setupImageLayout() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupNameLayout() {
        view.addSubview(nameLable)
        nameLable.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Layout.horizontalInset)
            make.bottom.equalToSuperview().inset(Layout.verticalInset)
        }
    }
    private func setupDetailLayout() {
        view.addSubview(detailLable)
        detailLable.snp.makeConstraints { make in
            make.top.equalTo(nameLable.snp.top).inset(Layout.verticalInset)
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
