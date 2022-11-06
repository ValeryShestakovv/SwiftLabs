import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: UIViewController {
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    let imageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleToFill
        return logo
    }()
    let nameLable: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return text
    }()
    let detailLable: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        text.numberOfLines = 0
        return text
    }()
    var topNameLableConstraint: Constraint?
    let effect = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageLayout()
        view.addSubview(effect)
        setupButtonLayout()
        backButton.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        setupNameLayout()
        setupDetailLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topNameLableConstraint?.update(inset: 700)
        UIView.animate(withDuration: 0.5) {
            self.effect.frame = self.view.frame
            self.effect.effect = UIBlurEffect(style: .dark)
            self.view.layoutIfNeeded()
        }
    }
    @objc func onButtonTap() {
        self.dismiss(animated: true)
        topNameLableConstraint?.update(inset: 40)
        backButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.effect.effect = nil
            self.view.layoutIfNeeded()
        }
    }
    private func setupImageLayout() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupButtonLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
        }
    }
    private func setupNameLayout() {
        view.addSubview(nameLable)
        nameLable.snp.makeConstraints { make in
            self.topNameLableConstraint = make.bottom.equalToSuperview().inset(40).constraint
            make.left.right.equalToSuperview().inset(40)
        }
    }
    private func setupDetailLayout() {
        view.addSubview(detailLable)
        detailLable.snp.makeConstraints { make in
            make.top.equalTo(nameLable.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.bottom.equalToSuperview().inset(Layout.horizontalInset)
        }
    }
    func compose(heroId: Int) {
        ServiceImp().getHero(idHero: heroId) { result in
            DispatchQueue.main.async {
                self.nameLable.text = result.name
                self.detailLable.text = result.details
            }
        }
    }
}

// MARK: Layout Guides

extension DetailViewController {
    enum Layout {
        static var horizontalInset: CGFloat { 50 }
        static var verticalInset: CGFloat { 100 }
    }
}
