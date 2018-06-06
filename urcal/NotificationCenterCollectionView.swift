
import UIKit
import PinLayout

class NotificationCenterView: UIView {
    fileprivate let collectionView: UICollectionView
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    fileprivate let cellTemplate = NotificationCenterCell()
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: .zero)
        configureCollectionView()
    }
    
    fileprivate func configureCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.register(NotificationCenterCell.self, forCellWithReuseIdentifier: "cellID")
    collectionView.dataSource = self
    collectionView.delegate = self
    flowLayout.minimumLineSpacing = 1
    addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.pin.all()
    }
    
    func configure() {
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCenterView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! NotificationCenterCell
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellTemplate.configure()
        return cellTemplate.sizeThatFits(CGSize(width: collectionView.bounds.width, height: .greatestFiniteMagnitude))
    }
}
