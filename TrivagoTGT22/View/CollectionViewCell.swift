import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "collectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(to image: UIImage){
        imageView.image = image
    }
}
