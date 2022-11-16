import SnapKit
import Kingfisher
import UIKit
import AnimatedCollectionViewLayout
import RealmSwift

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
    private var horisontalGallaryConstraint: Constraint?
    private var activityView: UIView?
    private var listHeroes: [HeroModel] = []
    private var totalHeroes: Int?
    private let service = ServiceImp()
    private let realm = try! Realm()
    lazy var heroesDB: Results<HeroModelDB> = { self.realm.objects(HeroModelDB.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        figure.backgroundColor = .red
        setupFigureLayout()
        setupLogoLayout()
        setupLabelLayout()
        setupGalleryLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSpinner()
        service.getListHeroes(offset: listHeroes.count) { result, total in
            self.listHeroes = result
            self.totalHeroes = total
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
                self.removeSpinner()
            }
        }
    }
    private func showSpinner() {
        activityView = UIView(frame: view.bounds)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .red
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffect.frame = view.frame
        activityView?.addSubview(blurEffect)
        activityView?.addSubview(activityIndicator)
        activityView?.alpha = 0
        view.addSubview(activityView!)
        UIView.animate(withDuration: 0.5) {
            self.activityView?.alpha = 1
        }
    }
    private func removeSpinner() {
        activityView?.alpha = 1
        horisontalGallaryConstraint?.update(inset: 0)
        UIView.animate(withDuration: 0.5) {
            self.activityView?.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.activityView?.removeFromSuperview()
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {
            return
        }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        guard
            let indexPath = galleryCollectionView.indexPathForItem(at: centerPoint),
            let cell = galleryCollectionView.dequeueReusableCell(
                withReuseIdentifier: GalleryCollectionViewCell.reuseId,
                for: indexPath) as? GalleryCollectionViewCell,
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if TestInternetConnection.connectedToNetwork() == true {
            return listHeroes.count
        } else {
            return heroesDB.count
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCollectionViewCell.reuseId,
            for: indexPath) as? GalleryCollectionViewCell else { return .init() }
        //        cell.compose(heroId: heroId)
        if TestInternetConnection.connectedToNetwork() == true {
            guard let imageUrl = URL(string: listHeroes[indexPath.row].imageStr + ".jpg") else {return cell}
            let resource = ImageResource(downloadURL: imageUrl)
            let placeholder = UIImage(named: "placeholder")
            cell.imageView.kf.setImage(with: resource, placeholder: placeholder)
            cell.nameLable.text = listHeroes[indexPath.row].name
//            let placeholderData = NSData(data: placeholder!.jpegData(compressionQuality: 1)!)
//            let object = self.realm.object(ofType: HeroModelDB.self, forPrimaryKey: "\(heroId)")
//            if object == nil {
//                let heroModel = HeroModelDB(name: result.name,
//                                            discription: result.details,
//                                            image: cell.imageView.image!,
//                                            idHero: heroId)
//                try! self.realm.write({
//                    self.realm.add(heroModel)
//                })
//            } else if object?.image == placeholderData {
//                try! self.realm.write({
//                    object?.image = NSData(data: cell.imageView.image!.jpegData(compressionQuality: 1)!)
//                })
//            }
//        } else {
//            cell.imageView.image = UIImage(data: heroesDB[indexPath.row].image as Data)
//            cell.nameLable.text = heroesDB[indexPath.row].name
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if listHeroes.count < totalHeroes ?? 0 && indexPath.row == listHeroes.count - 1 {
            service.getListHeroes(offset: listHeroes.count) { result, total in
                self.listHeroes.append(contentsOf: result)
                self.totalHeroes = total
                DispatchQueue.main.async {
                    self.galleryCollectionView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        guard let cell = galleryCollectionView.cellForItem(at: indexPath)
                        as? GalleryCollectionViewCell else { return }
        if TestInternetConnection.connectedToNetwork() == true {
            let heroId = listHeroes[indexPath.row].id
            detailViewController.imageView.image = cell.imageView.image
            detailViewController.compose(heroId: heroId)
        } else {
            detailViewController.imageView.image = UIImage(data:heroesDB[indexPath.row].image as Data)
            detailViewController.nameLable.text = heroesDB[indexPath.row].name
            detailViewController.detailLable.text = heroesDB[indexPath.row].discription
        }
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
        static var leftDistanceToView: CGFloat { 0 }
        static var rightDistanceToView: CGFloat { 0 }
        static var galleryMinimumLineSpacing: CGFloat { 0 }
        static let galleryItemWidth = (UIScreen.main.bounds.width - Layout.leftDistanceToView -
                                       Layout.rightDistanceToView - (Layout.galleryMinimumLineSpacing / 2))
        static let galleryItemHeight = UIScreen.main.bounds.height - 150
    }
}
