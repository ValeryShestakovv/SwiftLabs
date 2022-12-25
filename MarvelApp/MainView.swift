import SnapKit
import UIKit
import AnimatedCollectionViewLayout

final class MainView: UIViewController {
    private let logoView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    private let textLable: UILabel = {
        let textMarvel = UILabel()
        textMarvel.text = "Choose your hero".localize()
        textMarvel.textAlignment = .center
        textMarvel.textColor = .white
        textMarvel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        return textMarvel
    }()
    private let figure = TriangleView()
    private var layout = AnimatedCollectionViewLayout()
    private lazy var galleryCollectionView: UICollectionView = {
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
        figure.color = UIColor(named: "backgroundColor")
        setupSubviews()
        setupFigureLayout()
        setupLayouts()
        setupActivityLayout()
        loadHeroes()
    }
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupLayouts()
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
    private func showSpinner() {
        UIView.animate(withDuration: 0.5) {
            self.activityView.alpha = 1
        }
    }
    private func removeSpinner() {
        UIView.animate(withDuration: 0.5) {
            self.activityView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    private func setupSubviews() {
        view.addSubview(figure)
        view.addSubview(logoView)
        view.addSubview(textLable)
        view.addSubview(galleryCollectionView)
        view.addSubview(activityView)
    }
    private func setupActivityLayout() {
        activityView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityView.alpha = 0
    }
    private func setupFigureLayout() {
        figure.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setupLayouts() {
        if UIDevice.current.orientation.isLandscape {
            setupLandscapeLayout()
        }
        if UIDevice.current.orientation.isPortrait {
            setupPortraitLayout()
        }
    }
    private func setupPortraitLayout() {
        layout.scrollDirection = .horizontal
        galleryCollectionView.setCollectionViewLayout(layout, animated: true)
        logoView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
            make.height.equalTo(50)
        }
        textLable.snp.remakeConstraints { make in
            make.top.equalTo(logoView.snp.top).inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalTextInset)
            make.centerX.equalTo(logoView.snp.centerX)
        }
        galleryCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(textLable.snp.bottom).inset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func setupLandscapeLayout() {
        layout.scrollDirection = .vertical
        galleryCollectionView.setCollectionViewLayout(layout, animated: true)
        logoView.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(Layout.horizontalInset * 1.7)
            make.left.equalToSuperview()
            make.right.equalTo(view.snp.centerX)
        }
        textLable.snp.remakeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(30)
            make.centerX.equalTo(logoView.snp.centerX)
        }
        galleryCollectionView.snp.remakeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(view.snp.centerX)
        }
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
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

extension MainView: UICollectionViewDataSource {
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
        let detailView = DetailsHeroView(viewModel: detailViewModel)
        detailView.transitioningDelegate = self
        detailView.modalPresentationStyle = .custom
        if viewModel.connectedToNetwork == true {
            detailView.setupHero {
                guard self.presentedViewController == nil else {return}
                self.present(detailView, animated: true)
            }
        } else {
            detailView.setupHeroDB()
            guard self.presentedViewController == nil else {return}
            self.present(detailView, animated: true)
        }
    }
}

extension MainView: UIViewControllerTransitioningDelegate {
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

extension MainView {
    enum Layout {
        static var horizontalTextInset: CGFloat { 85 }
        static var horizontalInset: CGFloat { 90 }
        static var verticalInset: CGFloat { 80 }
        static var leftDistanceToView: CGFloat { 0 }
        static var rightDistanceToView: CGFloat { 0 }
        static var galleryMinimumLineSpacing: CGFloat { 0 }
        static var galleryItemWidth: CGFloat {
            if UIDevice.current.orientation.isLandscape {
                return UIScreen.main.bounds.width / 2
            } else {
                return UIScreen.main.bounds.width
            }
        }
        static var galleryItemHeight: CGFloat {
            if UIDevice.current.orientation.isLandscape {
                return UIScreen.main.bounds.height
            } else {
                return UIScreen.main.bounds.height - 150
            }
        }
    }
}
