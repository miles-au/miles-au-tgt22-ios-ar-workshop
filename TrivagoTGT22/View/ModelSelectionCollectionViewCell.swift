import UIKit

class ModelSelectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(to image: UIImage) {
        imageView.image = image
    }
}
