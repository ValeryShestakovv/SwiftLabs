import SnapKit
import Kingfisher
import UIKit
import AnimatedCollectionViewLayout

final class ViewController: UIViewController {
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
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Layout.leftDistanceToView,
                                                   bottom: 0, right: Layout.rightDistanceToView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    private var items: [HeroModel] = HeroModel.fetchHero()

    override func viewDidLoad() {
        super.viewDidLoad()
        figure.backgroundColor = .red
        setupFigureLayout()
        setupLogoLayout()
        setupLabelLayout()
        setupGalleryLayout()
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
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {
            return
        }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = galleryCollectionView.indexPathForItem(at: centerPoint) {
            let item = items[indexPath.row]
            figure.backgroundColor = item.color
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Layout.galleryItemWidth, height: Layout.galleryItemHeight)
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCollectionViewCell.reuseId,
            for: indexPath) as? GalleryCollectionViewCell else { return .init() }
        let item = items[indexPath.row]
        let resource = ImageResource(downloadURL: item.imageURL)
        let placeholder = UIImage(named: "placeholder")
        cell.imageView.kf.setImage(with: resource, placeholder: placeholder)
        cell.textLable.text = item.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let item = items[indexPath.row]
        let resource = ImageResource(downloadURL: item.imageURL)
        let placeholder = UIImage(named: "placeholder")
        detailViewController.imageView.kf.setImage(with: resource, placeholder: placeholder)
        detailViewController.nameLable.text = item.name
        detailViewController.detailLable.text = item.discription
        detailViewController.transitioningDelegate = self
        detailViewController.modalPresentationStyle = .custom
        present(detailViewController, animated: true)
    }
}
extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = galleryCollectionView.indexPathsForSelectedItems,
            let selectedCell = galleryCollectionView.cellForItem(at: (selectedIndexPathCell.first)!) as?
                GalleryCollectionViewCell,
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
            let selectedCell = galleryCollectionView.cellForItem(at: (selectedIndexPathCell.first)!) as?
                GalleryCollectionViewCell,
            let selectedCellSuperview = selectedCell.superview
        else {
            return nil
        }
        let originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        return AnimationController(animationDuration: 0.5, animationType: .dismiss, cellFrame: originFrame)
    }
}

// MARK: Layout Guides

extension ViewController {
    enum Layout {
        static var horizontalTextInset: CGFloat { 65 }
        static var horizontalInset: CGFloat { 90 }
        static var verticalInset: CGFloat { 80 }
        static var leftDistanceToView: CGFloat { 5 }
        static var rightDistanceToView: CGFloat { 0 }
        static var galleryMinimumLineSpacing: CGFloat { 25 }
        static let galleryItemWidth = (UIScreen.main.bounds.width - Layout.leftDistanceToView -
                                       Layout.rightDistanceToView - (Layout.galleryMinimumLineSpacing / 2))
        static let galleryItemHeight = UIScreen.main.bounds.height - 150
    }
}
