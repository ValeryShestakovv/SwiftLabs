import UIKit
import SnapKit

final class DetailsHeroViewController: UIViewController {
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0
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
    private var topNameLableConstraint: Constraint?
    private let effect = UIVisualEffectView()
    weak var viewModel: DetailsHeroViewModal? {
        didSet {
            self.imageView.image = UIImage(data: Data(referencing: viewModel?.hero.imageData ?? NSData()))
            self.nameLable.text = viewModel?.hero.name
            self.detailLable.text = viewModel?.hero.details
            if viewModel?.connectedToNetwork == true {
                viewModel?.downloadDetail { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let hero):
                        self.nameLable.text = hero.name
                        self.detailLable.text = hero.details
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                viewModel?.downloadImage { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let imageData):
                        self.imageView.image = UIImage(data: Data(referencing: imageData))
                    case .failure(let error):
                        self.imageView.image = UIImage(named: "placeholder")
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
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
            self.backButton.alpha = 1
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
}

// MARK: Layout Guides

extension DetailsHeroViewController {
    enum Layout {
        static var horizontalInset: CGFloat { 50 }
        static var verticalInset: CGFloat { 100 }
    }
}
