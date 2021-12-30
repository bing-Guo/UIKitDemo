import UIKit

class DemoCollectionViewController: UIViewController {
    let footerHeight: CGFloat = 40
    let perPageCount = 35
    
    var dataSource: [DemoItem] = []
    var page: Int = 0
    var isLoadingMore: Bool = false {
        didSet {
            if isLoadingMore {
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
            }
        }
    }
    
    /**
     Using in footer view. To implement infinite scroll loading animation.
     */
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    /**
     To implement infinite pull to refresh.
     */
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: String(describing: UICollectionReusableView.self))
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
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
        
        fetchData()
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - Actions
extension DemoCollectionViewController {
    func fetchData(isRefresh: Bool = false) {
        isLoadingMore = true
        
        APIService.shared.fetchDemoItem(perPageCount: perPageCount, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoadingMore = false
            self.refreshControl.endRefreshing()
            
            switch result {
            case let .success(items):
                guard items.count > 0 else { return }
                
                if isRefresh {
                    self.dataSource = items
                } else {
                    self.dataSource.append(contentsOf: items)
                }
                
                self.collectionView.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
    /**
     Detect whether is the end of the bottom
     */
    func loadNextPageIfNeeded(row: Int) {
        let triggerRow = dataSource.count - 5
        if (row > triggerRow) && !isLoadingMore {
            page += 1
            fetchData()
        }
    }
    
    @objc func refresh() {
        page = 0
        fetchData(isRefresh: true)
    }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                     withReuseIdentifier: String(describing: UICollectionReusableView.self),
                                                                     for: indexPath)
        
        footer.addSubview(indicatorView)
        indicatorView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: footerHeight)
        
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadNextPageIfNeeded(row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: footerHeight)
    }
}
