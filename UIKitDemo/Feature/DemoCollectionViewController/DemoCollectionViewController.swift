import UIKit

class DemoCollectionViewController: UIViewController {
    let dataSource: [DemoItem] = [
        DemoItem(title: "#4F726C", color: UIColor(hex: 0x4F726C)),
        DemoItem(title: "#F4A7B9", color: UIColor(hex: 0xF4A7B9)),
        DemoItem(title: "#D0104C", color: UIColor(hex: 0xD0104C)),
        DemoItem(title: "#F19483", color: UIColor(hex: 0xF19483)),
        DemoItem(title: "#B9887D", color: UIColor(hex: 0xB9887D)),
        DemoItem(title: "#563F2E", color: UIColor(hex: 0x563F2E)),
        DemoItem(title: "#ADA142", color: UIColor(hex: 0xADA142)),
        DemoItem(title: "#6E75A4", color: UIColor(hex: 0x6E75A4)),
    ]
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - Setup UI
extension DemoCollectionViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Actions
extension DemoCollectionViewController {
}

extension DemoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath) as? DemoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = dataSource[indexPath.row]
        cell.config(item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let columns: CGFloat = 4
        let space: CGFloat = flowayout.sectionInset.left + flowayout.sectionInset.right + (flowayout.minimumInteritemSpacing * (columns - 1))
        let width: CGFloat = (collectionView.frame.size.width - space) / columns
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
}
