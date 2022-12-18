import SnapKit
import UIKit
import AnimatedCollectionViewLayout

final class MainViewController: UIViewController {
    private let logoView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    private let textLable: UILabel = {
        let textMarvel = UILabel()
        textMarvel.text = "Choose your hero"
        textMarvel.textColor = .white
        textMarvel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return textMarvel
    }()
    private let figure = TriangleView()
    private lazy var galleryCollectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator(minAlpha: 0.5, itemSpacing: 0.3, scaleRate: 0.8)
        layout.minimumLineSpacing = Layout.galleryMinimumLineSpacing
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.register(GalleryCellView.self,
                                forCellWithReuseIdentifier: GalleryCellView.reuseId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Layout.leftDistanceToView,
                                                   bottom: 0, right: Layout.rightDistanceToView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .red
        collectionView.refreshControl?.addTarget(self,
                                                action: #selector(refresh(sender:)),
                                                for: .valueChanged)
        return collectionView
    }()
    private var horisontalGallaryConstraint: Constraint?
    private let activityView: UIView = {
        let view = UIView()
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
    let viewModel: MainViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        figure.backgroundColor = .red
        setupFigureLayout()
        setupLogoLayout()
        setupLabelLayout()
        setupGalleryLayout()
        setupActivityLayout()
        loadHeroes()
    }
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func refresh(sender: UIRefreshControl) {
        viewModel.refreshListHeroes {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    private func loadHeroes() {
        showSpinner()
        viewModel.getListHeroes {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
                self.removeSpinner()
            }
        }
    }
    private func setupActivityLayout() {
        view.addSubview(activityView)
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
        horisontalGallaryConstraint?.update(inset: 0)
        UIView.animate(withDuration: 0.5) {
            self.activityView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    private func setupFigureLayout() {
        view.addSubview(figure)
        figure.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupLogoLayout() {
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.height.equalTo(50)
        }
    }
    private func setupLabelLayout() {
        view.addSubview(textLable)
        textLable.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.top).inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalTextInset)
        }
    }
    private func setupGalleryLayout() {
        view.addSubview(galleryCollectionView)
        galleryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textLable.snp.bottom).inset(10)
            self.horisontalGallaryConstraint = make.left.equalToSuperview().inset(500).constraint
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {
            return
        }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        guard
            let indexPath = galleryCollectionView.indexPathForItem(at: centerPoint),
            let cell = galleryCollectionView.dequeueReusableCell(
                withReuseIdentifier: GalleryCellView.reuseId,
                for: indexPath) as? GalleryCellView,
            let color = cell.imageView.image?.averageColor else {
                return
            }
        figure.backgroundColor = color
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Layout.galleryItemWidth, height: Layout.galleryItemHeight)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfHeroes()
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCellView.reuseId,
            for: indexPath) as? GalleryCellView else { return .init() }
        let currentHero = self.viewModel.getCurrentHeroModal(index: indexPath.row)
        if viewModel.connectedToNetwork == true {
            cell.setupHero(currentHero) { [weak self] result in
                guard let self = self else {return}
                self.viewModel.addHeroToDB(hero: result)
            }
        } else {
            cell.setupHeroDB(currentHero)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if viewModel.connectedToNetwork == true {
            self.viewModel.getAddListHeroes(indexHero: indexPath.row) {
                DispatchQueue.main.async {
                    self.galleryCollectionView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentHero = viewModel.getCurrentHeroModal(index: indexPath.row)
        let detailViewModel = DetailsHeroViewModal(hero: currentHero)
        let detailViewController = DetailsHeroViewController(viewModel: detailViewModel)
        detailViewController.transitioningDelegate = self
        detailViewController.modalPresentationStyle = .custom
        if viewModel.connectedToNetwork == true {
            detailViewController.setupHero {
                self.present(detailViewController, animated: true)
            }
        } else {
            detailViewController.setupHeroDB()
            self.present(detailViewController, animated: true)
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = galleryCollectionView.indexPathsForSelectedItems,
            let selectedCell = galleryCollectionView.cellForItem(at: (selectedIndexPathCell.first)!) as?
                GalleryCellView,
            let selectedCellSuperview = selectedCell.superview
        else {
            return nil
        }
        let originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        return AnimationController(animationDuration: 0.5, animationType: .present, cellFrame: originFrame)
    }
    func animationController(forDismissed
                             dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = galleryCollectionView.indexPathsForSelectedItems,
            let selectedCell = galleryCollectionView.cellForItem(at: (selectedIndexPathCell.first!)) as?
                GalleryCellView,
            let selectedCellSuperview = selectedCell.superview
        else {
            return nil
        }
        let originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        return AnimationController(animationDuration: 0.5, animationType: .dismiss, cellFrame: originFrame)
    }
}

// MARK: Layout Guides

extension MainViewController {
    enum Layout {
        static var horizontalTextInset: CGFloat { 85 }
        static var horizontalInset: CGFloat { 90 }
        static var verticalInset: CGFloat { 80 }
        static var leftDistanceToView: CGFloat { 0 }
        static var rightDistanceToView: CGFloat { 0 }
        static var galleryMinimumLineSpacing: CGFloat { 0 }
        static let galleryItemWidth = (UIScreen.main.bounds.width - Layout.leftDistanceToView -
                                       Layout.rightDistanceToView - (Layout.galleryMinimumLineSpacing / 2))
        static let galleryItemHeight = UIScreen.main.bounds.height - 150
    }
}
