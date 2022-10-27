import UIKit

class DetailViewController: UIViewController {
    
    public let imageHero: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleToFill
        logo.translatesAutoresizingMaskIntoConstraints = false
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
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageHero)
        view.addSubview(nameHero)
        view.addSubview(detailHero)
        
        imageHero.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageHero.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageHero.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageHero.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nameHero.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        nameHero.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        detailHero.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        detailHero.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        detailHero.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

    }
    
}
