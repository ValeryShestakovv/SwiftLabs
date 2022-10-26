import SnapKit
import UIKit
import AnimatedCollectionViewLayout

final class ViewController: UIViewController {

    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private let label: UILabel = {
        let textMarvel = UILabel()
        textMarvel.text = "Choose your hero"
        textMarvel.textColor = .white
        textMarvel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        textMarvel.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Layout.leftDistanceToView, bottom: 0, right: Layout.rightDistanceToView)
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
        self.view.backgroundColor = UIColor(red: 0.16, green: 0.15, blue: 0.17, alpha: 0.9)
        view.addSubview(figure)
        view.addSubview(logo)
        view.addSubview(label)
        view.addSubview(galleryCollectionView)

        figure.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layout.verticalInset)
            make.left.right.equalToSuperview().inset(Layout.horizontalInset)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.top).inset(Layout.verticalInset)
            make.left.equalToSuperview().inset(Layout.horizontalTextInset)
            make.right.equalToSuperview().inset(Layout.horizontalTextInset)
        }

        galleryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).inset(10)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Layout.galleryItemWidth, height: Layout.galleryItemHeight)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as? GalleryCollectionViewCell else {
            return .init()
        }
        let item = items[indexPath.row]
        cell.mainImageView.image = item.image
        cell.textLable.text = item.name
        cell.color = item.color
        return cell
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
        static let galleryItemWidth = (UIScreen.main.bounds.width - Layout.leftDistanceToView - Layout.rightDistanceToView - (Layout.galleryMinimumLineSpacing / 2))
        static let galleryItemHeight = UIScreen.main.bounds.height - 150
    }
}
