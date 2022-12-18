import UIKit
import SnapKit
import Kingfisher

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
    let detailView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.backgroundColor = .none
        textView.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private var topNameLableConstraint: Constraint?
    private let effect = UIVisualEffectView()
    var viewModel: DetailsHeroViewModal

    init(viewModel: DetailsHeroViewModal) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageLayout()
        view.addSubview(effect)
        setupButtonLayout()
        setupNameLayout()
        setupDetailLayout()
        backButton.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
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
    func setupHero(complition: @escaping() -> Void) {
        viewModel.downloadDetails { [weak self] result in
            guard let self = self else {return}
            self.nameLable.text = result.name
            self.detailView.text = result.details
            guard let imageURL = URL(string: result.imageStr) else {return}
            let resource = ImageResource(downloadURL: imageURL)
            self.imageView.kf.setImage(with: resource, placeholder: UIImage(named: "placeholder")) { _ in
                complition()
            }
        }
    }
    func setupHeroDB() {
        nameLable.text = viewModel.hero.name
        detailView.text = viewModel.hero.details
        imageView.image = viewModel.hero.image
    }
    @objc func onButtonTap() {
        self.dismiss(animated: true)
        topNameLableConstraint?.update(inset: 40)
        backButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.effect.effect = nil
            self.detailView.alpha = 0
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
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top.equalTo(nameLable.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.bottom.equalToSuperview().inset(Layout.horizontalInset)
        }
    }
}

// MARK: Layout Guides

extension DetailsHeroViewController {
    enum Layout {
        static var horizontalInset: CGFloat { 35 }
        static var verticalInset: CGFloat { 100 }
    }
}
